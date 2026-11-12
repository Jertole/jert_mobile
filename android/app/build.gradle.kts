import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val releaseSigningProperties = Properties().apply {
    val propertiesFile = rootProject.layout.projectDirectory.file("key.properties")
    providers.fileContents(propertiesFile).asText.orNull?.reader()?.use { load(it) }
}
val releaseStorePassword = releaseSigningProperties.getProperty("storePassword")?.takeUnless { it.isBlank() }
val releaseKeyPassword = releaseSigningProperties.getProperty("keyPassword")?.takeUnless { it.isBlank() }

android {
    namespace = "com.jert.wallet"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.jert.wallet"
        
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
signingConfigs {
    create("release") {
        storeFile = file("../jert-release-key.jks")
        storePassword = releaseStorePassword
        keyAlias = "jert"
        keyPassword = releaseKeyPassword
    }
}
    buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
        isMinifyEnabled = false
        isShrinkResources = false
    }
}
}

val validateReleaseSigningPasswords = tasks.register("validateReleaseSigningPasswords") {
    val missingProperties = listOfNotNull(
        "storePassword".takeIf { releaseStorePassword == null },
        "keyPassword".takeIf { releaseKeyPassword == null },
    )
    doLast {
        if (missingProperties.isNotEmpty()) {
            throw GradleException(
                "Missing release signing properties in android/key.properties: " +
                    missingProperties.joinToString(),
            )
        }
    }
}

val releasePackagingTasks = setOf("packageRelease", "packageReleaseBundle", "signReleaseBundle")
tasks.matching { it.name in releasePackagingTasks }.configureEach {
    dependsOn(validateReleaseSigningPasswords)
}

flutter {
    source = "../.."
}
