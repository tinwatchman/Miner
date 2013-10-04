Miner
=====

Updated October 4, 2013.

A Minesweeper mobile game written for Adobe AIR.

Libraries/Dependencies:
* [Apache Flex 4.10.0 SDK](http://flex.apache.org/)
* [Starling](http://gamua.com/starling/)
* [Feathers UI](http://feathersui.com/)
* [PureMVC](http://puremvc.org/)

### Game Instructions

Should be pretty straightforward to anyone who's played the old Windows version. Touch a tile on the grid to select it. Touch it again to reveal the tile (and possibly explode).

### Known Issues
* Noticeable performance slowdown when a mine is selected and revealed (e.g. when losing the game). This seems to be due to adding a large number of Label components to the screen. Still looking for a way to optimize this.
* Noticeable performance slowdown when creating medium- and hard-difficulty games. More tiles means more overhead. Still working on how best to handle this.

### Other Notes
I used the PureMVC framework just to prove that I'm comfortable with it. However, I don't really believe that this framework is the best choice for AIR mobile apps or games, especially when using Starling. It tends to require a lot of boilerplate code to handle delayed instantiation views, and while its Notification system is fairly lightweight, it still adds yet another kind of event or message object flying around (in addition to Starling events and Flex/Flash events).

For reasons that are a mystery even to me, I decided to write all of the game's flavor text as if it'd been badly translated from some East European language. What can I say -- it seemed really funny to me at 1 am a few nights ago.