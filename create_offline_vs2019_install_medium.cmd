
echo off & color 0A
 
cd /e %~dp0
set currentPath=%cd%
echo currentPath=%currentPath%
 
call vs_Professional.exe --layout "%currentPath%"   --add Microsoft.VisualStudio.Component.CoreEditor  --add Microsoft.VisualStudio.Workload.ManagedDesktop  --add Microsoft.VisualStudio.Workload.ManagedGame  --add Microsoft.VisualStudio.Workload.NativeDesktop  --add Microsoft.VisualStudio.Workload.NativeGame  --add Microsoft.VisualStudio.Component.Windows10SDK.19041 --add Microsoft.VisualStudio.Component.VC.ASAN --add Microsoft.VisualStudio.Component.VC.DiagnosticTools --add Microsoft.VisualStudio.Component.Debugger.JustInTime --add Microsoft.VisualStudio.Component.VC.ATL --add Microsoft.VisualStudio.Component.VC.CMake.Project --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.VC.ATLMFC --add Microsoft.VisualStudio.Component.VC.CLI.Support --add Microsoft.VisualStudio.Component.VC.Llvm.Clang --add Microsoft.VisualStudio.Component.VC.Llvm.ClangToolset --add Microsoft.VisualStudio.Component.VC.Modules.x86.x64 --add Component.Incredibuild --add Component.IncredibuildMenu --add Microsoft.VisualStudio.Workload.VisualStudioExtension


echo "refer to https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community?view=vs-2019 for more info"
echo. & pause
