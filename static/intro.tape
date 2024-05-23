Output screen.gif

# Set up a 1200x600 terminal with 46px font.
Set FontSize 32
Set Width 1200
Set Height 1000
#Set Theme "Hipster Green"
Set Theme { "name": "Custom", "background": "#e6dfcf", "foreground": "#007700", "selectionBackground": "#3d3c58", "cursorAccent": "#b3b0d6", "cursor": "#b3b0d6" }
Set Shell "bash"

Hide
Type "rm -rf clace.db* && /usr/bin/clear" Enter
Show

Type "# Start the Clace server" Sleep 600ms Enter
Type "clace server start &" Sleep 600ms Enter
Sleep 1 Enter

Type "# Install app from GitHub url" Sleep 400ms Enter
Type "clace app create --approve github.com/claceio/apps/system/disk_usage /du" Sleep 400ms Enter
Sleep 2
Enter 2

Type "# List installed apps" Sleep 400ms Enter
Type "clace app list -f basic" Sleep 400ms Enter
Sleep 2
Enter 2

Type "# -i option shows internal apps" Sleep 400ms Enter
Type "clace app list -i -f basic" Sleep 400ms Enter
Sleep 2
Type "# Stage at https://localhost:25223/du_cl_stage" Enter
Sleep 1 Enter 2

Type "# reload fetches latest code from github" Sleep 400ms Enter
Type "clace app reload /du" Sleep 400ms Enter
Sleep 3 Enter 2

Type "clace app list -i -f basic" Enter 
Sleep 3 Enter 2

Type "# Promote version 2 to prod if stage looks good" Sleep 400ms Enter
Type "clace app promote /du" Sleep 400ms  Enter
Sleep 3 Enter 2

Type "clace version list -f basic /du" Sleep 400ms Enter
Sleep 3 Enter 2

Type "clace app list -i -f basic" Sleep 400ms Enter
Sleep 3 Enter 2
Type "# Prod and stage are in sync now" Enter
Type "# All code and config changes staged by default" Enter
Type "# No more scrambling to revert broken prod apps!!" Enter
Sleep 6
