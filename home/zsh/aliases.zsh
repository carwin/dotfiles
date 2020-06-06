# Webcam
alias webcam="mplayer tv:// -tv driver=v4l2:width=1920:height=1080:device=/dev/video0 -fps 15 -vf screenshot"

# Take a screenshot directly to the clipboard
alias scrot="scrot -s ~/foo.png && xclip -selection clipboard -t image/png ~/foo.png && rm ~/foo.png"

# Compress things real good
alias 7zultra='7z a -t7z -m0=lzma2 -mx=0 -mfb=64 -md=32m -ms=on'

# Curl headers through proxy
alias curlheaders="curl -I"
alias curlheadersproxy="curl --socks5 localhost:11080 -I"
