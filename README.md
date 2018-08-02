#SingleFileCopier

Copies a few individual files (hardcoded) to a new location (hardcoded), and changes behaviour depending on which computer it is run on. Can both push and pull files to and from the save location. The script is useful for files that are unsuited for continuous syncing to a cloud (folderpairs, etc), for instance game save files or anything that may cause sync conflicts. Currently used for pushing WeakAura files for World of Warcraft out of the settings folder (WorldOfWarcraft/WTF/AccountName/\*) and into a synced GoogleDrive folder, which can then be accessed from another computer and pulled into the settings folder again. 

It's currently very hard-coded, but it does exactly what I need it for, so I have not bothered adding more functionalty or removing the hard-code constraints. 

Note: It may be really easy to change this such that it works on copying folders as well by adding a "-recurse" to the copy-item cmdlet. I haven't tested this, but I don't imagine that there's anything else in the code that would prohibit this from working after applying the change. 