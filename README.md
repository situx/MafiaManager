# MafiaManager

MafiaManager is an Android app and an accompanying web application for creating, managing, and playing roleplaying games that follow the ruleset of the popular game Mafia.

## MafiaML
MafiaManager provides the definition of MafiaML, an XML datastructure in which characters, items and events for the popular roleplaying game Mafia can be defined.
This provides a unified XML standard for sharing Mafia decks among computers.
The standard will be introduced in the following sections:
### Gameset
MafiaML defines a gameset to include the following attributes:
- A unique gameset id
- The title of the gameset
- Minimum amount of players possible
- Maximum amount of players possible
- Coverimage and back image of the card if available
- Introtext and Outrotext for the gamemaster to announce a new round
```xml
<gameset gamesetid="56c7af97-9e68-4980-95d9-433933ff2326" title="Mafia" fromPlayers="0" toPlayers="0" img="de_mafia" backimg="back">
    <introtext introtitle="Beginning of the night">The night falls. All players go to sleep.</introtext>
    <outrotext outrotitle="End of the night">A new day begins</outrotext>
</gameset>
```
The purpose of a gameset description is to describe metainformation about the set of cards being used and might be expanded in the future.
### Groups
Every game of mafia consists of at least two factions which are eager to win the game. Usually those factions consist of at least the Mafiosi and the Citizens. In MafiaML, the following information about factions in the game are defined:
- name: Name of the group
- gid: A unique group id used for the gamemaster to distinguish groups
- id: A unique internally used group id
- icon: An image file associated with the group
- canwin: Indicates if the group can win the game or if members of the group need to change to another group in order to win the game
- description: A group description stating the groups intentions during the game
```xml
     <group name="Mafiosi" gid="M" id="7000902e-499c-489c-a3c5-6a3dcd3ca621" icon="5e59e8af-709a-4ccd-be47-da2d8d32cc18" canwin="true">
        <description>The Mafiosi win the game by killing all non-Mafiosi.</description>
    </group>
```
### Character Definition
```xml
    <Karte cardid="87d0cb39-fd39-455a-9a85-2912f52addb4" name="Barkeeper" group="M" round="0" img=" " minamount="1" maxamount="1" position="2" position2="-1" extra="0" fixeddeath="0" nopoints="false" calleveryone="false" winsalone="false" winningalive="2" winningdead="1" balance="0">
<description>The barkeeper can once prohibit an ability to be executed during the night. He wins along with the Mafiosi.</description>
```
### Abilities
```xml
<abb active="true" amount="1" availablefrom="1" availableuntil="-1" probability="100" img="jailguard" everyround="true" concerns="1" mustuse="false" duration="1" killing="false" counterKilling="false" self="false">Choose victim</abb>
```
### Actions
```xml
    <actions>
        <action id="1"  position="2" round="0" ondead="false" title="Choose victim">
            <gamemaster>Note the character which cannot perform actions during the night.</gamemaster>
            <player>Point out the victim</player>
        </action>
    </actions>
```
### Events

The gamesets provided in this Github repository do not include images of the gaming cards due to copyright reasons. I recommend the community to provide me with free to use images that I can include and/or encourage people who have bought official games to rely on those instead.
## MafiaManager App
An Android app allows the loading of specified Mafia decks and provides and aid for the gamemaster to guide through the Mafia game.
The app has originally been written for Android Version 4 in compatibility mode to Android 2 and 3 and has received no updates since. I would highly appreciate if someone would update the app and its code.
## MafiaManager Web Application
A character deck displaying and manipulation software is provided as a web application.



