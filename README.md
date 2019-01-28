# dotConfig -- W4RH4WK

## WSL

    "C:\Program Files\wsl-terminal\bin\mintty.exe" --wsl --rootfs=// --configdir "C:\Program Files\wsl-terminal\etc" -i "C:\Program Files\wsl-terminal\open-wsl.exe" -e /bin/wslbridge -e SHELL="/bin/bash" -e LANG -e DISPLAY=localhost:0 -t -C ~/Desktop --

- Add `Desktop` link to home directory
- Use [X410](https://www.microsoft.com/en-us/p/x410/9nlp712zmn9q)
- Use [wsl-terminal](https://github.com/goreliu/wsl-terminal)

## Ubuntu (VMWare)

- Replace package list after auto-install
- Replace *Snaps* with *native* packages
- Add `After=graphical.target` to `/etc/systemd/system/multi-user.target.wants/open-vm-tools.service`
