tell application "Finder"
    set cwd to POSIX path of ((target of front Finder window) as text)
    do shell script "open -a Visual\\ Studio\\ Code " & quoted form of cwd
end tell
