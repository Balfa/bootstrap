# install_caskaydia_cove.sh
# This installs a nerd-fonts version (better, patched with more glyphs) of the MS Cascadia Code fonts.
# (tested with NerdFonts v2.2.2, https://github.com/ryanoasis/nerd-fonts/releases/tag/v2.2.2)
# I haven't tested a way to execute it directly from the gist. It looks like, when I wrote it, the whole contents
# were just supposed to be copied and pasted into a git bash terminal

# This could probably replace the section in post-install-first-steps.txt for installing Cascadia Code PL, but
# it's probably not that important to do right now

zipFileUrl=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | jq -r '.assets[] | select(.name == "CascadiaCode.zip") | .browser_download_url')
zipFileName=$(echo $zipFileUrl | awk -F/ '{print $NF}' )
wget $zipFileUrl
7z x -o./unzipped $zipFileName
cp ./unzipped/*.otf /c/Windows/Fonts/
pushd ./unzipped/
for FONTFILE in *.otf;
do
WITHOUT_EXTENSION="${FONTFILE%.*}"
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" //v "$WITHOUT_EXTENSION" //t REG_SZ //d "$FONTFILE" //f
done;
popd;
rm -rf ./unzipped;
rm $zipFileName;

