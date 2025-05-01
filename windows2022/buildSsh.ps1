echo "cloudflared start"
curl.exe -JLO https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe
ls
#./cloudflared-windows-amd64.exe service install ${{ secrets.cloud_winrdp }}
#net user runneradmin ${{ secrets.pass }}
echo "end "