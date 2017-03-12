# icloud-docs
This iOS app creates a file on iCloud Drive so that it can be seen in a Finder folder 
This project is just a simple example of an app which creates files in iCloud Drive and has the Folder display in Finder on a Mac.  Steps as follows:

1.Given the brittle nature of this iCloud stuff, I recommend starting with a new project, using this code as a guide.  You may be able to clone/edit/run this project, I have not tried.

2.Go to The TARGET Capabilities tab – enable iCloud.  Select **iCloud Documents** and **Specify custom container**.  It does not need to follow the same path as your bundle.  I just entered “iCloudDocs” and it created ```iCloud.iCloudDocs```.  

3.Go to Info tab and create your keys for your ```Info.plist```:
```
	<key>NSUbiquitousContainers</key>
		<dict>
			<key>iCloud.iCloudDocs</key>
			<dict>
				<key>NSUbiquitousContainerIsDocumentScopePublic</key>
				<true/>
				<key>NSUbiquitousContainerName</key>
				<string>MyDocs</string>
				<key>NSUbiquitousContainerSupportedFolderLevels</key>
				<string>Any</string>
			</dict>
		</dict>
```
* ```NSUbiquitousContainerIsDocumentScopePublic```of course needs to be YES (true).  This is what tells the system that you want it to appear in Finder, etc.

* ```NSUbiquitousContainerName``` is what will appear in Finder.  Note that it does not need to match or in any way relate to the bundle name or the name you gave on the NSUbiquitousContainers key.

* I am not sure what all the acceptable values are for ```NSUbiquitousContainerSupportedFolderLevels``` are – some folks say One, some Any, some None… I just stick with Any.

4.Write your code.  This project is the simplest way I know to show a sample app that creates a document in **iCloud Drive** and shows it in **Finder** – it accepts a string of text and then it writes it to a file.  It places the file in a Documents directory.

* The code in the beginning of ```ViewController``` shows the right way to create the file for iCloud and uses the UIDocument class for saving and retrieving.

5.Run your code.  If all works, you should see a Folder under “iCloud Drive” in Finder.  If you don’t see “iCloud Drive” in your Finder Sidebar, you can go to Finder->Preferences to add it.

* By the way, if you create the Container and don’t have any files in it, it will appear as a hidden folder.  Once you add files, it appears as a regular folder.

* There is a definite time lag between the time the file is saved and when it appears in Finder.  The folder seems to appear long before the file does.

* If you don’t see the Folder in Finder, check in Terminal to see if it was even created.  If you are running my code, then iCloud~iCloudDocs should appear when you do the following: 
		```cd ~/Library/Mobile\ Documents; ls –a```
* If that worked, then you can cd to the folder and see if the file is there.  If the file is not, then wait a few minutes or run the app again (maybe I have a file close problem).  If the folder and file appear in Terminal but the assigned Container Name does not appear in Finder, then either your Info.plist data is messed up or you have fallen into the iCloud vortex and may need to start again!


	Hope it helps!
