--------------------------
--Strings for faf_coop_U01
--------------------------
local HQvid5 = 'UEFHQ_5.sfd'
local HQvid10 = 'UEFHQ_10.sfd'
local HQvid15 = 'UEFHQ_15.sfd'
local Arnoldvid5 = 'UEFArnold_5.sfd'
local Arnoldvid10 = 'UEFArnold_10.sfd'
local Arnoldvid15 = 'UEFArnold_15.sfd'
local UEFBank = 'U01_UEFAudio'

--Objective Titles and Descriptions.

    Ob1_Title = 'Establish Mass Resource Operations'
    Ob1_Desc = 'Build 2 Mass Extractors with your Commander.'
    Ob1a_Title = 'Establish Power Resource Operations'
    Ob1a_Desc = 'Build 4 Power Generators with your Commander.'
    Ob1b_Title = 'Establish Construction Operations'
    Ob1b_Desc = 'Build a Land Factory with your Commander.'

    Ob2_Title = 'Build 10 Light Assault Bots'
    Ob2_Desc = 'Build 10 Light Assault Bots at the Land Factory.'
    Ob2_TitleAlt = 'Prepare for the Cybran Assault'
    Ob2_DescAlt = 'Construct Bots and Defenses to prepare for the Cybran assault.'
    Ob2a_Title = 'Survive the Cybran raids'
    Ob2a_Desc = 'Defend yourself from the raiding Cybran units.'
    Ob2b_Title = 'Survive the Cybran attack'
    Ob2b_Desc = 'Destroy the Cybran attacks units.'

    Ob3_Title = 'Destroy Cybran Forward Bases'
    Ob3_Desc = 'Destroy the Cybran Base structures.'

    Ob4_Title = 'Take Control of the Coms Station'
    Ob4_Desc = 'Capture the UEF Coms Station.'
    Ob4a_Title = 'Defend the Coms Station'
    Ob4a_Desc = 'Do not allow the Coms Station to be destroyed.'
    Ob4b_Title = 'Hold for the Communication Uplink'
    Ob4b_Desc = 'Defend the Coms Station for 5 minutes.'

    Ob5_Title = 'Destroy the Cybran Support Commander'
    Ob5_Desc = 'A Cybran Sleeper Agent is operating a Support Commander in the area. Destroy it!'
    Ob5a_Title = 'Destroy the Cybran Base'
    Ob5a_Desc = 'Destroy the Cybran Base so they can no longer pose a threat.'

--Secondary Objective Titles and Descriptions.

    Ob5Sec1_Title = 'Destroy the Cybran Supporting Base.'
    Ob5Sec1_Desc = 'Destroy the Cybran secondary base to end the production of air units.'
    Ob5Sec2_Title = 'Destroy the Cybran Mass Extractors.'
    Ob5Sec2_Desc = 'Destroy the Cybran Mass Extractors in the river valley to cripple unit production.'

--Dialogue
--Type(Objective # _ Dialogue # _ Step #)
--text = '', vid = _, bank = '', cue = '', faction = ''

--Main Dialogue Listing
Main1_1 = {
    {text = '[HQ]: Sir, you need to move quickly! The Quantum wake will have announced your arrival! Begin by establishing a solid foundation at your current position. Construct mass extractors, power generators and a land factory. EarthCom, out.',
    vid = HQvid15, bank = UEFBank, cue = 'Main1_1', faction = 'UEF'},
}

Main1_2 = {
    {text = '[HQ]: Sir, we have confirmed that you have built a base. We are uploading additional blueprints for the Tech 1 point defence turret and Tech 1 wall segment. You are advised to use them to defend your base! EarthCom, out.',
    vid = HQvid15, bank = UEFBank, cue = 'Main1_2', faction = 'UEF'},
}

Main1_3 = {
    {text = '[HQ]: Sir, we have confirmed that you have got around to building a base! We are uploading additional blueprints for the Tech 1 point defence turret and Tech 1 wall segment. EarthCom, out.',
    vid = HQvid10, bank = UEFBank, cue = 'Main1_3', delay = 2, faction = 'UEF'},
}

Main1_4 = {
    {text = '[HQ]: Sir, the Cybran are not going to wait all day! Intelligence shows you are out of time! Construct your base when able!',
    vid = HQvid10, bank = UEFBank, cue = 'Main1_4', faction = 'UEF'},
}

Main2_1_1 = {
    {text = '[HQ]: Sir, we have identified multiple Cybran signatures closing on your position! We are sending you an emergency data burst for the Tech 1 Light Assault Bot blueprint!', 
    vid = HQvid10, bank = UEFBank, cue = 'Main2_1_1', faction = 'UEF'},
    --Main2_1_2
    {text = '[HQ]: The Light Assault Bot is a fast and lightly armoured unit that can be constructed at the land factory quickly. Use them to fend off early raids! EarthCom, out.', 
    vid = HQvid10, bank = UEFBank, cue = 'Main2_1_2', faction = 'UEF'},
}

Main2a_1 = {
    {text = '[HQ]: Sir, the raids are about to hit you! EarthCom, out.', 
    vid = HQvid5, bank = UEFBank, cue = 'Main2a_1', faction = 'UEF'},
}

Main2a_2 = {
    {text = '[HQ]: Sir, there are a large number of Cybran units closing on your position! EarthCom, out.',
    vid = HQvid5, bank = UEFBank, cue = 'Main2a_2', faction = 'UEF'},
}

Main2b_1 = {
    {text = '[HQ]: Glad you see you alive, Sir! We are tracking the origin of the attack and will have a location for you shortly. EarthCom, out.', 
    vid = HQvid10, bank = UEFBank, cue = 'Main2b_1', faction = 'UEF'},
}

Main3_1_1 = {
    {text = '[HQ]: Sir, intelligence has determined that the attack came from a nearby Cybran outpost, located in the mountain pass! Signal returns are sporadic, and intel suggests it may be an automated base.', 
    vid = HQvid10, bank = UEFBank, cue = 'Main3_1_1', faction = 'UEF'},
    --Main3_1_2
    {text = '[HQ]: The outpost must be destroyed before you can proceed with your mission, sir! EarthCom, out.', 
    vid = HQvid5, bank = UEFBank, cue = 'Main3_1_2', duration = 3, faction = 'UEF'},
    --Main3_1_3
    {text = '[HQ]: Sir, we have uploaded the blueprints required for Tech 1 land operations to your ACU. Proceed with destroying the Cybran Outpost! Good Luck! EarthCom, out.', 
    vid = HQvid10, bank = UEFBank, cue = 'Main3_1_3', faction = 'UEF'},
}

Main3_2 = {
    {text = '[HQ]: Confirming the destruction of the Cybran Outpost! Good job, sir! EarthCom, out.', 
    vid = HQvid5, bank = UEFBank, cue = 'Main3_2', faction = 'UEF'},
}

Main4_1_1 = {
    {text = '[HQ]: Sir, we are detecting additional Cybran units in the area. We suspect the Cybrans are aware of our objective! General Clarke orders you to proceed to the Quantum Communication Relay and take control of the installation, without further delay! EarthCom, out.', 
    vid = HQvid15, bank = UEFBank, cue = 'Main4_1_1', faction = 'UEF'},
    --Main4_1_2 (merged with 4_1_1 to make 15s)
    --{text = '[HQ]: General Clarke orders you to proceed to the Quantum Communication Relay and take control of the installation, without further delay! EarthCom, out.', 
    --vid = HQvid15, bank = UEFBank, cue = 'Main4_1_2', faction = 'UEF'},
}

Main4_2 = {
    {text = '[HQ]: Confirming connection with the Quantum Communication Array. Sir, it will take approximately 5 minutes to establish secure communication channels and break the Cybran jamming. You need to ensure the facility remains intact for the duration! EarthCom, out.', 
    vid = HQvid15, bank = UEFBank, cue = 'Main4_2', faction = 'UEF'},
}

Main4a_1_1 = {
    {text = '[HQ]: Connection established. Security protocols initiated and secure. EarthCom to Colonel Marcus.', 
    vid = HQvid10, bank = UEFBank, cue = 'Main4a_1_1', faction = 'UEF'},
    --Main4a_1_2
    {text = '[Marcus]: Command? It\'s about damn time! Command, you need to get reinforcements planet-side immediately! This isn\'t just some Cybran raid. It\'s a damn invasion!', 
    vid = Arnoldvid10, bank = UEFBank, cue = 'Main4a_1_2', duration = 3, faction = 'UEF'},
    --Main4a_1_3
    {text = '[HQ]: Colonel, what is your current situation?', 
    vid = HQvid5, bank = UEFBank, cue = 'Main4a_1_3', faction = 'UEF'},
    --Main4a_1_4
    {text = '[Marcus]: Deteriorating! I\'m on the defensive and have three ACUs pushing my position! You tell General Clarke I need reinforcements now, or the only thing left will be a damn crater the size of my ACU!', 
    vid = Arnoldvid10, bank = UEFBank, cue = 'Main4a_1_4', faction = 'UEF'},
    --Main4a_1_5 (Merged with 4a_1_6 to make 10s)
    --{text = '[HQ]: Standby Colonel.', 
    --vid = HQvid5, bank = UEFBank, cue = 'Main4a_1_5', duration = 5, faction = 'UEF'},
    --Main4a_1_6
    {text = '[HQ]: Colonel, standby. Sir, General Clarke has placed you under the command of Colonel Marcus. Your orders are to proceed to his position and assist him as he sees fit! EarthCom, out!', 
    vid = HQvid10, bank = UEFBank, cue = 'Main4a_1_6', faction = 'UEF'},
    --Main4a_1_7
    {text = '[Marcus]: Perfect! I need reinforcements, and all I get is a green Commander with a barely functioning ACU! Listen here, I\'m not going to put my ass on the line to save yours! Follow my orders, and maybe we\'ll both come out of this alive!', 
    vid = Arnoldvid15, bank = UEFBank, cue = 'Main4a_1_7', faction = 'UEF'},
}

Main5_1_1 = {
    {text = '[HQ]: Sir, we have confirmed that a Cybran Support Commander is operating in the river valley north of the mountain pass and is responsible for the attacks on your position. EarthCom, out.', 
    vid = HQvid10, bank = UEFBank, cue = 'Main5_1_1', faction = 'UEF'},
    --Main5_1_2
    {text = '[Marcus]: Damn. If you leave him, he\'ll flank your position! Take him out!', 
    vid = Arnoldvid5, bank = UEFBank, cue = 'Main5_1_2', faction = 'UEF'},
}

Main5_2 = {
    {text = '[HQ]: Sir, we are registering that the Cybran Commander and base have been destroyed! The area is secure, and you are clear to proceed to Colonel Marcus\' position. EarthCom, out.', 
    vid = HQvid10, bank = UEFBank, cue = 'Main5_2', faction = 'UEF'},
}

--Side Dialogue listing
Side5_1_1 = {
    {text = '[HQ]: Sir, the Cybran has constructed a supportive Airbase west of his position. Destroy the Airbase, and the Cybran won\'t be able to launch air attacks on your forces!', 
    vid = HQvid10, bank = UEFBank, cue = 'Side5_1_1', faction = 'UEF'},
    --Side5_1_2
    {text = '[HQ]: The T1 Air Factory and T1 Interceptor have been uploaded to your ACU. You can directly counter the Cybran air power in the region. However, be cautious, sir. If you dedicate too many resources to air power, the Cybran land forces can overwhelm you! EarthCom, out.',
    vid = HQvid15, bank = UEFBank, cue = 'Side5_1_2', faction = 'UEF'},
}

Side5_2 = {
    {text = '[HQ]: Sir, the Cybran Airbase has been destroyed! EarthCom, out.', 
    vid = HQvid5, bank = UEFBank, cue = 'Side5_2', faction = 'UEF'},
}

Side5_3 = {
    {text = '[HQ]: Sir, the Cybran Commander is relying on several Mass Extractors in the river valley to supply the mass needed to construct units. If you destroy them, it will starve the factories of mass! EarthCom, out.', 
    vid = HQvid15, bank = UEFBank, cue = 'Side5_3', faction = 'UEF'},
}

Side5_4 = {
    {text = '[HQ]: Good job on taking out those mass extractors, sir! EarthCom, out.', 
    vid = HQvid5, bank = UEFBank, cue = 'Side5_4', faction = 'UEF'},
}

--Info Dialogue listing
Info2b_1 = {
    {text = '[HQ]: The Cybran attack is made up of several Assault Bots. Engage with caution, Sir.', 
    vid = HQvid5, bank = UEFBank, cue = 'Info2b_1', faction = 'UEF'},
}

Info4_1 = {
    {text = '[HQ] Sir, the Communication Array is taking damage! EarthCom, out.', 
    vid = HQvid5, bank = UEFBank, cue = 'Info4_1', faction = 'UEF'},
}

Info4_2 = {
    {text = '[HQ]: Sir, the Communication Array has taken substantial damage! Step up your defensive operations immediately! EarthCom, out.', 
    vid = HQvid10, bank = UEFBank, cue = 'Info4_2', faction = 'UEF'},
}

Info4a_1 = {
    {text = '[HQ]: Jamming protocols decoded. Sir, we\'re halfway there! EarthCom, out.', 
    vid = HQvid5, bank = UEFBank, cue = 'Info4a_1', faction = 'UEF'},
}

Info4a_2 = {
    {text = '[HQ]: Clean frequency isolated. Sir, we\'re nearly done! EarthCom, out.', 
    vid = HQvid5, bank = UEFBank, cue = 'Info4a_2', faction = 'UEF'},
}

--Extra Dialogue listing
Extra1_1 = {
    {text = '[HQ]: Sir, we are detecting that you are low on mass. We recommend that you reclaim the wreckage and vegetation in the surrounding area to restore your mass and energy reserves. EarthCom, out.',
    vid = HQvid10, bank = UEFBank, cue = 'Extra1_1', faction = 'UEF'},
}

Extra3_1 = {
    {text = '[HQ]: Sir, the enemy is using Point Defence turrets. If you\'re having trouble penetrating their defence line, we recommend using the Lobo Tech 1 Mobile Artillery to counter the turrets. EarthCom, out.', 
    vid = HQvid10, bank = UEFBank, cue = 'Extra3_1', faction = 'UEF'},
}

Extra3_2 = {
    {text = '[HQ]: Sir, we have detected a Tech 2 Stealth Field Generator! Your radar is useless as long as it remains online! We recommend making it your priority target! EarthCom, out.', 
    vid = HQvid10, bank = UEFBank, cue = 'Extra3_2', faction = 'UEF'},
}

Extra4_1 = {
    {text = '[HQ]: Sir, the remains of a UEF base are near your position. You can restore the wreckage to working order by building the same type of structure over the wreck. This will save you significant resources and time! EarthCom, out.',
    vid = HQvid15, bank = UEFBank, cue = 'Extra4_1', faction = 'UEF'},
}

--Failure Dialogue
ObDeath = {
    {text = '[HQ]: Lieutenant? Come in, Lieutenant! Lieutenant, what is your status?', 
    vid = HQvid5, bank = UEFBank, cue = 'ObDeath', faction = 'UEF'},
}

ObComsDeath = {
    {text = '[HQ]: Sir, the Quantum Communication Relay has been destroyed! Our operation has been compromised! Prepare for immediate recall and debrief! EarthCom, out.', 
    vid = HQvid10, bank = UEFBank, cue = 'ObComsDeath', faction = 'UEF'},
}

--Cinematic Dialogue
Cinema1 = {
    {text = '[Hall]: Good morning, Lieutenant. We have a serious situation in the Matar system. Our last report indicated that Cybran have launched a raid on the system. Commanders in the system were holding the line. However, we recently lost communication with them. We need to assess the situation and restore communications asap!', 
    vid = HQvid15, bank = UEFBank, cue = 'Cinema1', faction = 'UEF'},
}

Cinema2 = {
    {text = '[Hall]: You will gate into this mountain pass. Its remote location will delay any Cybran forces from moving on your position. You will construct a base of operations here before moving on to your objective.', 
    vid = HQvid10, bank = UEFBank, cue = 'Cinema2', faction = 'UEF'},
}

Cinema3 = {
    {text = '[Hall]: Our primary objective is to restore communications with UEF forces. To achieve this objective, you will secure and defend a UEF Quantum Communications relay north of your position! The installation itself was evacuated, but the defences and systems should still be online.', 
    vid = HQvid15, bank = UEFBank, cue = 'Cinema3', faction = 'UEF'},
}

Cinema4 = {
    {text = '[Hall]: Although intelligence suggests the frontline is several kilometers from your position, there are still Cybran scouts operating in the area. So remain on your guard.', 
    vid = HQvid10, bank = UEFBank, cue = 'Cinema4', faction = 'UEF'},
}

Cinema5 = {
    {text = '[Hall]: Good luck, Lieutenant!', 
    vid = HQvid5, bank = UEFBank, cue = 'Cinema5', faction = 'UEF'},
}