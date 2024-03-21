$extensions = get-content .\extensions.txt

$extensions | ForEach-Object { "code-server --install-extension " + $_ + " && \"} | clip