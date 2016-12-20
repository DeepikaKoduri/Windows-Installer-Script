A simple script to create win executable for node modules.

This script is for the modules shipped separately from your core application.

The installer generated with this script checks if the core app is installed. The default install path is set to core app's location if it's installed. Otherwise, it's set to 'Program Files'. In either case, the user is allowed to modify the install path.

Edit Defaults.iss file to give meaningful values to the constants and also, check the [Files] section, and alter source and destination paths to fit your app requirements.
