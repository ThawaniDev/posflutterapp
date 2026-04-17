#!/usr/bin/env python3
"""Convert Flutter Scaffold pages to PosListPage / PosFormPage.

Handles the common cases:
- Scaffold(appBar: AppBar(title: Text(X)[, actions: [...]]), body: BODY[, floatingActionButton: FAB])
- Converts IconButton → PosButton.icon in actions
- Converts FAB → PosButton in actions
- Consolidates pos_* widget imports into widgets.dart barrel

Usage: python3 scripts/convert_pages.py FILE [FILE...] [--form]
       (--form forces PosFormPage conversion for that file list)
"""
import re
import sys
from pathlib import Path

# POS widget imports to consolidate
POS_WIDGET_IMPORTS = [
    'pos_button', 'pos_card', 'pos_input', 'pos_badge', 'pos_status_badge',
    'pos_empty_state', 'pos_error_state', 'pos_loading_skeleton',
    'pos_page_header', 'pos_stats_grid', 'pos_section', 'pos_tabs',
    'pos_chip_group', 'pos_data_table', 'pos_dialog', 'pos_form_card',
    'pos_divider', 'pos_timeline_tile', 'pos_info_banner', 'pos_avatar',
    'pos_breadcrumb', 'pos_progress_bar', 'pos_searchable_dropdown',
    'pos_stock_dot', 'pos_count_badge', 'pos_list_page', 'pos_form_page',
    'pos_dashboard_page', 'pos_detail_page', 'pos_scaffold',
]


def consolidate_imports(src: str, ensure_barrel: bool = False) -> str:
    """Remove individual pos_*.dart widget imports and add widgets.dart barrel once."""
    lines = src.split('\n')
    out = []
    already_has_barrel = False
    removed = False
    for line in lines:
        m = re.match(r"import\s+'package:wameedpos/core/widgets/(pos_[a-z_]+)\.dart';", line.strip())
        if m and m.group(1) in POS_WIDGET_IMPORTS:
            removed = True
            continue
        if "import 'package:wameedpos/core/widgets/widgets.dart';" in line:
            already_has_barrel = True
        out.append(line)

    if (removed or ensure_barrel) and not already_has_barrel:
        # Insert widgets.dart barrel near the other wameedpos imports
        for i, line in enumerate(out):
            if line.startswith("import 'package:wameedpos/core/widgets/"):
                out.insert(i, "import 'package:wameedpos/core/widgets/widgets.dart';")
                break
        else:
            for i, line in enumerate(out):
                if line.startswith("import 'package:wameedpos/"):
                    out.insert(i, "import 'package:wameedpos/core/widgets/widgets.dart';")
                    break
    return '\n'.join(out)


def find_matching(src: str, start: int, open_ch: str, close_ch: str) -> int:
    """Return index of matching close char, given src[start] == open_ch."""
    depth = 0
    i = start
    in_str = None  # ' or " or None
    while i < len(src):
        c = src[i]
        if in_str:
            if c == '\\':
                i += 2
                continue
            if c == in_str:
                in_str = None
        else:
            if c in ("'", '"'):
                in_str = c
            elif c == open_ch:
                depth += 1
            elif c == close_ch:
                depth -= 1
                if depth == 0:
                    return i
        i += 1
    return -1


def extract_param(src: str, key: str) -> tuple[int, int, str] | None:
    """Find param `key: <value>` at top-level of the Scaffold(...) call.
    Returns (start_idx_of_key, end_idx_past_value, value_text) or None."""
    # Find `key:` at current level (caller must pass in a balanced region)
    i = 0
    depth = 0
    in_str = None
    while i < len(src):
        c = src[i]
        if in_str:
            if c == '\\':
                i += 2; continue
            if c == in_str: in_str = None
            i += 1; continue
        if c in ("'", '"'):
            in_str = c; i += 1; continue
        if c in '([{': depth += 1
        elif c in ')]}': depth -= 1
        elif depth == 0 and src[i:i+len(key)+1] == f'{key}:' and (i == 0 or not src[i-1].isalnum() and src[i-1] != '_'):
            # Skip whitespace
            j = i + len(key) + 1
            while j < len(src) and src[j] in ' \t\n': j += 1
            # Value is everything until next top-level comma or end
            vstart = j
            vd = 0
            vin = None
            while j < len(src):
                cc = src[j]
                if vin:
                    if cc == '\\': j += 2; continue
                    if cc == vin: vin = None
                    j += 1; continue
                if cc in ("'", '"'):
                    vin = cc; j += 1; continue
                if cc in '([{': vd += 1
                elif cc in ')]}':
                    if vd == 0: break
                    vd -= 1
                elif cc == ',' and vd == 0:
                    break
                j += 1
            return (i, j, src[vstart:j].strip())
        i += 1
    return None


def convert_scaffold_to_poslistpage(src: str, show_search=False) -> tuple[str, bool]:
    """Find a Scaffold(...) call and replace with PosListPage(...). Returns (new_src, changed)."""
    # Locate 'Scaffold(' at build method scope
    m = re.search(r'\breturn\s+Scaffold\s*\(', src)
    if not m:
        m = re.search(r'\bScaffold\s*\(', src)
        if not m:
            return src, False
        scaffold_call_start = m.start()
    else:
        scaffold_call_start = m.end() - len('Scaffold(')

    open_paren = m.end() - 1
    close_paren = find_matching(src, open_paren, '(', ')')
    if close_paren < 0:
        return src, False

    body_text = src[open_paren+1:close_paren]

    # Parse out appBar, body, floatingActionButton, bottomNavigationBar
    def get(key):
        # Re-scan body_text each call
        r = extract_param(body_text, key)
        return r

    appbar = get('appBar')
    body = get('body')
    fab = get('floatingActionButton')
    bottomnav = get('bottomNavigationBar')

    if not appbar or not body:
        return src, False

    appbar_val = appbar[2]

    # Extract title from AppBar(title: Text(...) or AppBar(title: SOMETHING, ...)
    # Match AppBar( ... )
    m_ab = re.match(r'AppBar\s*\(', appbar_val)
    if not m_ab:
        # Could be PosAppBar - different handling; skip.
        return src, False
    ab_open = m_ab.end() - 1
    ab_close = find_matching(appbar_val, ab_open, '(', ')')
    if ab_close < 0:
        return src, False
    ab_inside = appbar_val[ab_open+1:ab_close]

    title_p = extract_param(ab_inside, 'title')
    if not title_p:
        return src, False
    title_val = title_p[2]

    # Skip if AppBar has a 'bottom:' (TabBar) — needs manual handling
    if extract_param(ab_inside, 'bottom'):
        return src, False
    # Accept simple Text(...) OR Row(children: [... Text(X) ...]) titles
    title_strip = title_val.strip()
    if not re.match(r'(const\s+)?Text\s*\(', title_strip) and not re.match(r'(const\s+)?Row\s*\(', title_strip):
        return src, False

    actions_p = extract_param(ab_inside, 'actions')
    leading_p = extract_param(ab_inside, 'leading')

    # Unwrap `Text('X')` or `const Text("X")` -> X
    title_expr = title_val.strip()
    mt = re.match(r"(?:const\s+)?Text\s*\(\s*(.+?)\s*\)\s*$", title_val.strip(), re.DOTALL)
    if mt:
        title_expr = mt.group(1).strip()
        # If we captured extra params like , style: ..., split on top-level comma
        parts = split_top_commas(title_expr)
        title_expr = parts[0].strip()
    else:
        # Try to extract Text(...) from within a Row
        mr = re.search(r'Text\s*\(\s*([^,)]+?)\s*\)', title_val.strip())
        if mr:
            title_expr = mr.group(1).strip()

    # Convert actions IconButton → PosButton.icon
    actions_val = actions_p[2] if actions_p else None
    new_actions_entries: list[str] = []
    if actions_val:
        # Strip outer [ ... ]
        if actions_val.startswith('[') and actions_val.endswith(']'):
            inner = actions_val[1:-1]
        else:
            inner = actions_val
        # Split on commas at depth 0
        parts = split_top_commas(inner)
        for p in parts:
            p = p.strip().rstrip(',').strip()
            if not p:
                continue
            new_actions_entries.append(convert_action(p))

    # Convert FAB → PosButton
    if fab:
        fab_val = fab[2].strip()
        new_actions_entries.append(convert_fab(fab_val))

    # Body: strip leading "const " if trivial
    body_val = body[2].strip()

    # If body is Padding(padding: ..., child: X) wrapping a single child, keep it (PosListPage adds its own padding, but keep author intent)

    # Build PosListPage
    actions_block = ''
    if new_actions_entries:
        actions_block = 'actions: [\n  ' + ',\n  '.join(new_actions_entries) + ',\n],\n'

    show_search_str = 'false' if not show_search else 'true'

    bottombar_block = ''
    # If bottomNavigationBar was a Padding(child: SaveButton), we can't easily extract — leave as a separate wrapping.

    new_scaffold = (
        f'PosListPage(\n'
        f'  title: {title_expr},\n'
        f'  showSearch: {show_search_str},\n'
        f'  {actions_block}'
        f'  child: {body_val},\n'
        f')'
    )

    # If there's a bottomNavigationBar, we need to keep Scaffold-like structure.
    # For simplicity, emit PosListPage but wrap in Column with bottomnav at end.
    if bottomnav:
        bn_val = bottomnav[2].strip()
        new_scaffold = (
            f'Column(\n'
            f'  children: [\n'
            f'    Expanded(child: PosListPage(\n'
            f'      title: {title_expr},\n'
            f'      showSearch: {show_search_str},\n'
            f'      {actions_block}'
            f'      child: {body_val},\n'
            f'    )),\n'
            f'    {bn_val},\n'
            f'  ],\n'
            f')'
        )

    # Replace the original Scaffold(...) call (including "return Scaffold(" if present)
    full_start = scaffold_call_start
    full_end = close_paren + 1
    new_src = src[:full_start] + new_scaffold + src[full_end:]
    return new_src, True


def split_top_commas(s: str) -> list[str]:
    parts = []
    depth = 0
    in_str = None
    last = 0
    i = 0
    while i < len(s):
        c = s[i]
        if in_str:
            if c == '\\': i += 2; continue
            if c == in_str: in_str = None
            i += 1; continue
        if c in ("'", '"'):
            in_str = c
        elif c in '([{':
            depth += 1
        elif c in ')]}':
            depth -= 1
        elif c == ',' and depth == 0:
            parts.append(s[last:i])
            last = i + 1
        i += 1
    parts.append(s[last:])
    return parts


def convert_action(expr: str) -> str:
    """Convert an AppBar action element to PosButton.icon where reasonable; else return as-is."""
    # IconButton(icon: Icon(I), onPressed: X, tooltip: Y)
    m = re.match(r'IconButton\s*\(\s*(.*)\s*\)$', expr, re.DOTALL)
    if m:
        inner = m.group(1)
        icon_p = extract_param(inner, 'icon')
        onp_p = extract_param(inner, 'onPressed')
        tip_p = extract_param(inner, 'tooltip')
        if icon_p and onp_p:
            icon_val = icon_p[2].strip()
            # Unwrap `const Icon(X)` or `Icon(X, ...)` -> X
            mi = re.match(r'(?:const\s+)?Icon\s*\(\s*([^,)]+)\s*(?:,.*)?\)\s*$', icon_val, re.DOTALL)
            if mi:
                icon_val = mi.group(1).strip()
            onp_val = onp_p[2].strip()
            parts = [f'icon: {icon_val}', f'onPressed: {onp_val}']
            if tip_p:
                parts.append(f'tooltip: {tip_p[2].strip()}')
            return f'PosButton.icon(\n    {", ".join(parts)},\n  )'
    return expr


def convert_fab(expr: str) -> str:
    """Convert FAB to a PosButton to be placed in actions list."""
    # FloatingActionButton.extended(onPressed: P, label: Text(L), icon: Icon(I))
    m = re.match(r'FloatingActionButton\.extended\s*\(\s*(.*)\s*\)$', expr, re.DOTALL)
    if m:
        inner = m.group(1)
        onp = extract_param(inner, 'onPressed')
        lab = extract_param(inner, 'label')
        icn = extract_param(inner, 'icon')
        label_val = lab[2].strip() if lab else "''"
        ml = re.match(r'Text\s*\(\s*(.+?)\s*(?:,.*)?\)\s*$', label_val, re.DOTALL)
        if ml:
            label_val = ml.group(1).strip()
        icon_val = icn[2].strip() if icn else 'Icons.add'
        mi = re.match(r'(?:const\s+)?Icon\s*\(\s*([^,)]+)\s*(?:,.*)?\)\s*$', icon_val, re.DOTALL)
        if mi:
            icon_val = mi.group(1).strip()
        onp_val = onp[2].strip() if onp else 'null'
        return f'PosButton(\n    label: {label_val},\n    icon: {icon_val},\n    size: PosButtonSize.sm,\n    onPressed: {onp_val},\n  )'

    # FloatingActionButton(onPressed: P, child: Icon(I), tooltip: T)
    m = re.match(r'FloatingActionButton\s*\(\s*(.*)\s*\)$', expr, re.DOTALL)
    if m:
        inner = m.group(1)
        onp = extract_param(inner, 'onPressed')
        child = extract_param(inner, 'child')
        tip = extract_param(inner, 'tooltip')
        icon_val = 'Icons.add'
        if child:
            mi = re.match(r'(?:const\s+)?Icon\s*\(\s*([^,)]+)\s*(?:,.*)?\)\s*$', child[2].strip(), re.DOTALL)
            if mi:
                icon_val = mi.group(1).strip()
        onp_val = onp[2].strip() if onp else 'null'
        # Use tooltip as the label if present, else 'Add'
        label = tip[2].strip() if tip else "'Add'"
        return f'PosButton.icon(\n    icon: {icon_val},\n    onPressed: {onp_val},\n    tooltip: {label},\n  )'

    return expr


def main():
    args = sys.argv[1:]
    if not args:
        print('Usage: convert_pages.py FILE [FILE...]')
        sys.exit(1)

    results = []
    for fp in args:
        p = Path(fp)
        if not p.exists():
            results.append((fp, 'MISSING'))
            continue
        src = p.read_text()
        # Skip files that need manual handling
        if 'SingleTickerProviderStateMixin' in src or 'TickerProviderStateMixin' in src:
            results.append((fp, 'skip-tabs'))
            continue
        if 'bottomNavigationBar:' in src:
            results.append((fp, 'skip-bottomnav'))
            continue
        src, changed = convert_scaffold_to_poslistpage(src, show_search=False)
        if changed:
            src = consolidate_imports(src, ensure_barrel=True)
            p.write_text(src)
            results.append((fp, 'converted'))
        else:
            results.append((fp, 'unchanged'))

    for fp, st in results:
        print(f'{st:12s} {fp}')


if __name__ == '__main__':
    main()
