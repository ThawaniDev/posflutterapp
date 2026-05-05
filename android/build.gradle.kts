allprojects {
    repositories {
        google()
        mavenCentral()
        // EdfaPay SoftPOS private maven repository — scoped to EdfaPay artifacts only
        maven {
            url = uri("https://maven.edfapay.com/repository/edfapay-sdk/")
            credentials {
                username = (project.findProperty("PARTNER_REPO_USERNAME") as String?) ?: ""
                password = (project.findProperty("PARTNER_REPO_PASSWORD") as String?) ?: ""
            }
            content {
                includeGroup("com.edfapay")
                includeGroup("edfapay")
                includeGroupByRegex("com\\.edfapay.*")
            }
        }
    }
    // Exclude xpp3 globally — it duplicates XmlPullParser classes already in kxml2
    configurations.all {
        exclude(group = "xpp3", module = "xpp3")
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    // Exclude xpp3 after each subproject is evaluated — it duplicates XmlPullParser
    // classes already provided by kxml2 (brought in by EdfaPay SDK transitive deps).
    afterEvaluate {
        configurations.all {
            exclude(group = "xpp3", module = "xpp3")
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
