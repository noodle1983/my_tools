
echo off & color 0A
 
cd /e %~dp0
set currentPath=%cd%
echo currentPath=%currentPath%
 
call vs_enterprise__d8ded0839de6470d8b78ecfe909dedbd.exe --layout "%currentPath%"   --add Microsoft.VisualStudio.Component.CoreEditor  --add Microsoft.VisualStudio.Workload.ManagedDesktop  --add Microsoft.VisualStudio.Workload.ManagedGame  --add Microsoft.VisualStudio.Workload.NativeDesktop  --add Microsoft.VisualStudio.Workload.NativeGame  --add Microsoft.VisualStudio.Component.Windows10SDK.19041 --add Microsoft.VisualStudio.Component.VC.ASAN --add Microsoft.VisualStudio.Component.VC.DiagnosticTools --add Microsoft.VisualStudio.Component.Debugger.JustInTime --add Microsoft.VisualStudio.Component.VC.ATL --add Microsoft.VisualStudio.Component.VC.CMake.Project --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.VC.ATLMFC --add Microsoft.VisualStudio.Component.VC.CLI.Support --add Microsoft.VisualStudio.Component.VC.Llvm.Clang --add Microsoft.VisualStudio.Component.VC.Llvm.ClangToolset --add Microsoft.VisualStudio.Component.VC.Modules.x86.x64 --add Microsoft.VisualStudio.Workload.VisualStudioExtension --add Microsoft.Net.Component.4.7.1.TargetingPack --add Microsoft.VisualStudio.Component.NuGet --add Microsoft.VisualStudio.Component.Roslyn.Compiler --add Microsoft.VisualStudio.Component.Roslyn.LanguageServices --add Microsoft.VisualStudio.Component.Unity --add Microsoft.VisualStudio.Component.IntelliCode --add Microsoft.VisualStudio.Component.IntelliTrace.FrontEnd


echo "refer to https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-enterprise?view=vs-2022 for more info"
echo. & pause
