# AGP 9 enables R8 full mode by default. Full mode does not keep no-arg
# constructors that are only reached via reflection (Class.newInstance /
# getDeclaredConstructor().newInstance). WorkManager creates WorkDatabase_Impl
# that way during androidx.startup.InitializationProvider, so release builds
# crash with NoSuchMethodException unless the constructor is kept explicitly.
# See: https://developer.android.com/topic/performance/app-optimization/full-mode
-keep class androidx.work.impl.WorkDatabase_Impl {
    <init>();
}

# WorkManager also reflects on Worker / InputMerger constructors.
-keep class * extends androidx.work.Worker
-keep class * extends androidx.work.InputMerger
-keep public class * extends androidx.work.ListenableWorker {
    public <init>(...);
}
