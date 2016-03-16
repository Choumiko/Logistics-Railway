Logistics Railway 1.0.3
=======================

Version 1.0.3 was released March 17, 2016, was tested using Factorio v0.12.26, and was authored by Supercheese.

This mod allows you to load/unload your trains using your logistics robots! You don't need to change your trains at all -- simply replace some of your normal rail segments with one of the types of special Logistics Rails and any cargo wagon that stops on those rails will be automagically converted into a Logistics Wagon of the associated type.
Then you can remove your inserters and chests and use only bots!
For example: If a wagon stops on top a Passive Provider rail, then its contents will be provided directly to the logistics network just like a passive provider chest.
You can, additionally, determine visually when a regular wagon becomes a Logistics Wagon when its alt-view cargo icons shrink in size.
In order to use Requester Rails, click them to set the logistics requests for any wagon that stops on top of them. You can, of course, copy/paste between Requester Rails just like with regular Requester Chests.

The recipe for all Logistics Rails is merely a single regular rail piece, and when you remove a Logistics Rail, you receive a regular rail, for maximum flexibility.


Known Issues/Quirks:
--------------------

Any time a Cargo Wagon becomes a Logistics Wagon, its inventory is dumped into a separate invisible entity, and it is in fact that entity that interacts with the logistics network.
When its inventory has been given to the other entity, the wagon's regular inventory is emptied and you are prevented from interacting with the wagon at all, unless you manually stop the train.

Requester Rails have a dummy item (blue ball icon) auto-inserted on creation. This allows them to have logistics requests set but not actually request any items until a wagon comes along.
Please do not remove this dummy item; You needn't concern yourself with it, as it will be properly dealt with by the mod code.

Sadly it seems that you cannot quick-replace regular rails with Logistics Rails, even after setting the appropriate property in the entity prototypes, but you can rotate the logistics rails by 90� and then place them over the existing rails, then re-place them in the proper orientation.

Logistics rails can only be placed horizontally or vertically. You really wouldn't want to make a diagonal loading/unloading station anyway... would you?

This mod is NOT compatible with other mods that introduce logistics wagons such as 5dim Trains. It is, however, compatible with Bob's mods, Stainless Steel Wagon, and other such wagon mods that don't use control.lua.


Credits:
--------

I was originally inspired to make this mod by a conversation on IRC between Afforess and Fatmice. Props to you guys for coming up with the idea!

5dim Trains has Logistics Wagons, but they are locked into always being requesters or providers, and don't change based on the rails beneath them.
Nonetheless, it was that mod that inspired me to create this one, although they do not share any code or graphics.

The little blue ball icon used for Requester Rails was obtained from: https://www.iconfinder.com/icons/38770/ball_blue_icon
That page states: "License: Free for commercial use".

All other graphics are modified from Factorio base assets.

Thanks to the forum and #factorio IRC denizens for camaraderie, advice, & bugtesting.

See also the associated forum thread to give feedback, view screenshots & tutorials, etc.:

https://forums.factorio.com/viewtopic.php?f=93&t=21462
