TableViewExample
==
This example shows how to create a UITableView with cells that have text and images. Unlike most examples, mine had certain requirements.

* Each cell has an image that would be at most 1/3 the width of the screen.
* The image must touch the top and bottom of the row.
* The image had to be at least a certain height.
* The image should attempt to have the aspect ratio of the original image. (Aspect Fit could leave white space; Aspect Fill could hide some of the image.)
* Images are loaded asynchronously from the Internet.
* Next to the image is up to 5 lines of text pinned to the top.
* Next to the image is 1 line of text pinned to the bottom.
* Each line of text could wrap to multiple lines.
* Increasing the type sized must resize the rows.
* The cell must have a minimum height.
* Rotating the device must work.


Please see my blog post at: [https://blog.gruby.com/2018/12/27/auto-layout-in-a-uitableviewcell-with-an-image/](https://blog.gruby.com/2018/12/27/auto-layout-in-a-uitableviewcell-with-an-image/).


Credits
==========
Photos are loaded from http://picsum.photos. Please see the site for copyright information.

