-- Allow Magic Eraser to Delete these items.
local AllowedDeleteItems = {
    -- Trash Consumables
    -- https://www.wowhead.com/classic/items/consumables/food-and-drinks?filter=82:2:92;4:2:1;11400:0:0#0+1+20
    [8932] = true, -- Alterac Swiss
    [16166] = true, -- Bean Soup
    [18635] = true, -- Bellara's Nutterbar
    [17404] = true, -- Blended Bean Brew
    [2723] = true, -- Bottle of Dalaran Noir
    [19300] = true, -- Bottled Winterspring Water
    [4593] = true, -- Bristle Whisker Catfish
    [21031] = true, -- Cabbage Kimchi
    [17344] = true, -- Candy Cane
    [19222] = true, -- Cheap Beer
    [4600] = true, -- Cherry Grog
    [19306] = true, -- Crunchy Frog
    [4599] = true, -- Cured Ham Steak
    [414] = true, -- Dalaran Sharp
    [19223] = true, -- Darkmoon Dog
    [19221] = true, -- Darkmoon Special Reserve
    [2070] = true, -- Darnassian Bleu
    [21030] = true, -- Darnassus Kimchi Pie
    [19225] = true, -- Deep Fried Candybar
    [8953] = true, -- Deep Fried Plantains
    [17119] = true, -- Deeprun Rat Kabob
    [4607] = true, -- Delicious Cave Mold
    [8948] = true, -- Dried King Bolete
    [422] = true, -- Dwarven Mild
    [13724] = true, -- Enriched Manna Biscuit
    [18287] = true, -- Evermurky
    [3927] = true, -- Fine Aged Cheddar
    [19299] = true, -- Fizzy Faire Drink
    [2594] = true, -- Flagon of Dwarven Honeymead
    [4604] = true, -- Forest Mushroom Cap
    [4541] = true, -- Freshly Baked Bread
    [4539] = true, -- Goldenbark Apple
    [17407] = true, -- Graccu's Homemade Meat Pie
    [17402] = true, -- Greatfather's Winter Ale
    [11444] = true, -- Grim Guzzler Boar
    [2287] = true, -- Haunch of Meat
    [16168] = true, -- Heaven Peach
    [17406] = true, -- Holiday Cheesewheel
    [17196] = true, -- Holiday Spirits
    [8950] = true, -- Homemade Cherry Pie
    [1179] = true, -- Ice Cold Milk
    [2595] = true, -- Jug of Badlands Bourbon
    [4595] = true, -- Junglevine Wine
    [4592] = true, -- Longjaw Mud Snapper
    [1205] = true, -- Melon Juice
    [4542] = true, -- Moist Cornbread
    [18288] = true, -- Molasses Firewater
    [4602] = true, -- Moon Harvest Pumpkin
    [1645] = true, -- Moonberry Juice
    [18632] = true, -- Moonbrook Riot Taffy
    [21721] = true, -- Moonglow
    -- [8766]      = true,   -- Morning Glory Dew
    [4544] = true, -- Mulgore Spice Bread
    [3770] = true, -- Mutton Chop
    [19305] = true, -- Pickled Kodo Foot
    [21033] = true, -- Radish Kimchi
    [4608] = true, -- Raw Black Truffle
    [19224] = true, -- Red Hot Wings
    [4605] = true, -- Red-speckled Mushroom
    [159] = true, -- Refreshing Spring Water
    [2894] = true, -- Rhapsody Malt
    -- [8952]      = true,   -- Roasted Quail
    [4594] = true, -- Rockscale Cod
    [4536] = true, -- Shiny Red Apple
    [2596] = true, -- Skin of Dwarven Stout
    [787] = true, -- Slitherskin Mackerel
    [4538] = true, -- Snapvine Watermelon
    [4601] = true, -- Soft Banana Bread
    [3703] = true, -- Southshore Stout
    [11109] = true, -- Special Chicken Feed
    [19304] = true, -- Spiced Beef Jerky
    [17408] = true, -- Spicy Beefstick
    [8957] = true, -- Spinefin Halibut
    [4606] = true, -- Spongy Morel
    [16170] = true, -- Steamed Mandu
    [17403] = true, -- Steamwheedle Fizzy Spirits
    [1707] = true, -- Stormwind Brie
    [21552] = true, -- Striped Yellowtail
    [18633] = true, -- Styleen's Sour Suckerpop
    [1708] = true, -- Sweet Nectar
    [4537] = true, -- Tel'Abim Banana
    [2686] = true, -- Thunder Ale
    [7228] = true, -- Tigule's Strawberry Ice Cream
    [4540] = true, -- Tough Hunk of Bread
    [117] = true, -- Tough Jerky
    [16167] = true, -- Versicolor Treat
    [9260] = true, -- Volatile Rum
    [3771] = true, -- Wild Hog Shank
    [16169] = true, -- Wild Ricecake
    [22324] = true, -- Winter Kimchi
    -- Trash White Equipment
    -- https://www.wowhead.com/classic/items/quality:1/slot:16:5:8:10:1:23:7:21:2:22:13:15:26:28:14:3:25:17:6:9?filter=195%3A2%3A5%3A85%3A82%3B1%3A2%3A2%3A5%3A4%3B0%3A0%3A0%3A0%3A11400
    -- Filtered out things that were tools, or RP, or related to quests.
    -- https://www.wowhead.com/classic/items/quality:1/slot:16:5:8:10:1:23:7:21:2:22:13:15:26:28:14:3:25:17:6:9?filter=195%3A2%3A5%3A85%3A82%3B1%3A2%3A2%3A1%3A4%3B0%3A0%3A0%3A0%3A11400
    --    [6292]      = true,     -- 10 Pound Mud Snapper
    --    [6294]      = true,     -- 12 Pound Mud Snapper
    --    [6295]      = true,     -- 15 Pound Mud Snapper
    --    [13901]      = true,     -- 15 Pound Salmon
    --    [6309]      = true,     -- 17 Pound Catfish
    --    [13902]      = true,     -- 18 Pound Salmon
    --    [6310]      = true,     -- 19 Pound Catfish
    --    [6311]      = true,     -- 22 Pound Catfish
    --    [13903]      = true,     -- 22 Pound Salmon
    --    [13904]      = true,     -- 25 Pound Salmon
    --    [6363]      = true,     -- 26 Pound Catfish
    --    [13905]      = true,     -- 29 Pound Salmon
    --    [6364]      = true,     -- 32 Pound Catfish
    --    [13906]      = true,     -- 32 Pound Salmon
    --    [13885]      = true,     -- 34 Pound Redgill
    --    [13886]      = true,     -- 37 Pound Redgill
    --    [13882]      = true,     -- 42 Pound Redgill
    --    [13883]      = true,     -- 45 Pound Redgill
    --    [13884]      = true,     -- 49 Pound Redgill
    --    [13887]      = true,     -- 52 Pound Redgill
    --    [13914]      = true,     -- 70 Pound Mightfish
    --    [13915]      = true,     -- 85 Pound Mightfish
    --    [13916]      = true,     -- 92 Pound Mightfish
    --    [13917]      = true,     -- 103 Pound Mightfish
    [14115] = true, -- Aboriginal Bands
    [14116] = true, -- Aboriginal Cape
    [14169] = true, -- Aboriginal Shoulder Pads
    [2487] = true, -- Acolyte Staff
    [59] = true, -- Acolyte's Shoes
    [2503] = true, -- Adept Short Staff
    [4672] = true, -- Ancestral Belt
    [3289] = true, -- Ancestral Boots
    [3642] = true, -- Ancestral Bracers
    [4671] = true, -- Ancestral Cloak
    [3290] = true, -- Ancestral Gloves
    [55] = true, -- Apprentice's Boots
    --    [6219]      = true,     -- Arclight Spanner
    [2419] = true, -- Augmented Chain Belt
    [2420] = true, -- Augmented Chain Boots
    [2421] = true, -- Augmented Chain Bracers
    [2422] = true, -- Augmented Chain Gloves
    [3891] = true, -- Augmented Chain Helm
    [2418] = true, -- Augmented Chain Leggings
    [2417] = true, -- Augmented Chain Vest
    [7048] = true, -- Azure Silk Hood
    [9400] = true, -- Baelog's Shortbow
    [2946] = true, -- Balanced Throwing Dagger
    [17187] = true, -- Banded Buckler
    [1193] = true, -- Banded Buckler
    [10405] = true, -- Bandit Shoulders
    [4687] = true, -- Barbaric Cloth Belt
    [3644] = true, -- Barbaric Cloth Bracers
    [4686] = true, -- Barbaric Cloth Cloak
    --    [5739]      = true,     -- Barbaric Harness
    [6555] = true, -- Bard's Cloak
    [5319] = true, -- Bashing Pauldrons
    [1194] = true, -- Bastard Sword
    [2371] = true, -- Battered Leather Belt
    [2373] = true, -- Battered Leather Boots
    [2374] = true, -- Battered Leather Bracers
    [2375] = true, -- Battered Leather Gloves
    [2370] = true, -- Battered Leather Harness
    [2372] = true, -- Battered Leather Pants
    [9403] = true, -- Battered Viking Shield
    [926] = true, -- Battle Axe
    [3279] = true, -- Battle Chain Boots
    [3280] = true, -- Battle Chain Bracers
    [4668] = true, -- Battle Chain Cloak
    [4669] = true, -- Battle Chain Girdle
    [3281] = true, -- Battle Chain Gloves
    [6526] = true, -- Battle Harness
    [3650] = true, -- Battle Shield
    [2527] = true, -- Battle Staff
    [2361] = true, -- Battleworn Hammer
    [14088] = true, -- Beaded Cloak
    [14093] = true, -- Beaded Cord
    [14087] = true, -- Beaded Cuffs
    [14089] = true, -- Beaded Gloves
    [14086] = true, -- Beaded Sandals
    [2025] = true, -- Bearded Axe
    [3190] = true, -- Beatstick
    --    [3422]      = true,     -- Beautiful Wildflowers
    [35] = true, -- Bent Staff
    --    [6367]      = true,     -- Big Iron Fishing Pole
    [4563] = true, -- Billy Club
    [3025] = true, -- BKP 42 "Ultra"
    [3024] = true, -- BKP 2700 "Enforcer"
    [2069] = true, -- Black Bear Hide Vest
    [3545] = true, -- Black Leather D02 Bracers
    [3420] = true, -- Black Rose
    --    [6834]      = true,     -- Black Tuxedo
    --    [6835]      = true,     -- Black Tuxedo Pants
    [5239] = true, -- Blackbone Wand
    [1445] = true, -- Blackrock Pauldrons
    --    [5956]      = true,     -- Blacksmith Hammer
    [15490] = true, -- Bloodspattered Cloak
    [15496] = true, -- Bloodspattered Shoulder Pads
    [3225] = true, -- Bloodstained Knife
    [7683] = true, -- Bloody Brass Knuckles
    [18612] = true, -- Bloody Chain Boots
    [8626] = true, -- Blue Sparkler
    [7095] = true, -- Bog Boots
    --    [3424]      = true,     -- Bouquet of Black Roses
    --    [3423]      = true,     -- Bouquet of White Roses
    [3303] = true, -- Brackwater Bracers
    [4680] = true, -- Brackwater Cloak
    [3304] = true, -- Brackwater Gauntlets
    [4681] = true, -- Brackwater Girdle
    [140] = true, -- Brawler's Boots
    [2424] = true, -- Brigandine Belt
    [2426] = true, -- Brigandine Boots
    [2427] = true, -- Brigandine Bracers
    [2428] = true, -- Brigandine Gloves
    [3894] = true, -- Brigandine Helm
    [2425] = true, -- Brigandine Leggings
    [2423] = true, -- Brigandine Vest
    [2479] = true, -- Broad Axe
    [2520] = true, -- Broadsword
    [6651] = true, -- Broken Wine Bottle
    [2849] = true, -- Bronze Axe
    --    [7958]      = true,     -- Bronze Battle Axe
    --    [7957]      = true,     -- Bronze Greatsword
    [2848] = true, -- Bronze Mace
    [2850] = true, -- Bronze Shortsword
    --    [7956]      = true,     -- Bronze Warhammer
    [4343] = true, -- Brown Linen Pants
    [2568] = true, -- Brown Linen Vest
    [14170] = true, -- Buccaneer's Mantle
    [6523] = true, -- Buckled Harness
    [2523] = true, -- Bullova
    [2617] = true, -- Burning Robes
    [5210] = true, -- Burning Wand
    [4694] = true, -- Burnished Pauldrons
    [15895] = true, -- Burnt Buckler
    [4665] = true, -- Burnt Cloak
    [4666] = true, -- Burnt Leather Belt
    [2963] = true, -- Burnt Leather Boots
    [3200] = true, -- Burnt Leather Bracers
    [2964] = true, -- Burnt Leather Gloves
    [2169] = true, -- Buzzer Blade
    [9758] = true, -- Cadet Belt
    [9759] = true, -- Cadet Boots
    [9760] = true, -- Cadet Bracers
    [9761] = true, -- Cadet Cloak
    [9762] = true, -- Cadet Gauntlets
    [8179] = true, -- Cadet's Bow
    [4692] = true, -- Ceremonial Cloak
    [3311] = true, -- Ceremonial Leather Ankleguards
    [4693] = true, -- Ceremonial Leather Belt
    [3312] = true, -- Ceremonial Leather Bracers
    [847] = true, -- Chainmail Armor
    [1845] = true, -- Chainmail Belt
    [849] = true, -- Chainmail Boots
    [1846] = true, -- Chainmail Bracers
    [850] = true, -- Chainmail Gloves
    [848] = true, -- Chainmail Pants
    [15472] = true, -- Charger's Belt
    [15474] = true, -- Charger's Bindings
    [15473] = true, -- Charger's Boots
    [15475] = true, -- Charger's Cloak
    [15476] = true, -- Charger's Handwraps
    [15478] = true, -- Charger's Shield
    [2615] = true, -- Chromatic Robe
    [1198] = true, -- Claymore
    [2029] = true, -- Cleaver
    [2130] = true, -- Club
    [5236] = true, -- Combustible Wand
    --    [2845]      = true,     -- Copper Axe
    [2853] = true, -- Copper Bracers
    --    [2851]      = true,     -- Copper Chain Belt
    [3469] = true, -- Copper Chain Boots
    [2852] = true, -- Copper Chain Pants
    [7955] = true, -- Copper Claymore
    [7166] = true, -- Copper Dagger
    [2844] = true, -- Copper Mace
    [2847] = true, -- Copper Shortsword
    [2122] = true, -- Cracked Leather Belt
    [2123] = true, -- Cracked Leather Boots
    [2124] = true, -- Cracked Leather Bracers
    [2125] = true, -- Cracked Leather Gloves
    [2126] = true, -- Cracked Leather Pants
    [2127] = true, -- Cracked Leather Vest
    [2522] = true, -- Crescent Axe
    [2451] = true, -- Crested Heater Shield
    [7062] = true, -- Crimson Silk Pantaloons
    [7058] = true, -- Crimson Silk Vest
    [1388] = true, -- Crooked Staff
    [3111] = true, -- Crude Throwing Axe
    [2492] = true, -- Cudgel
    [2142] = true, -- Cuirboulli Belt
    [2143] = true, -- Cuirboulli Boots
    [2144] = true, -- Cuirboulli Bracers
    [2145] = true, -- Cuirboulli Gloves
    [2146] = true, -- Cuirboulli Pants
    [2141] = true, -- Cuirboulli Vest
    [236] = true, -- Cured Leather Armor
    [1849] = true, -- Cured Leather Belt
    [238] = true, -- Cured Leather Boots
    [1850] = true, -- Cured Leather Bracers
    [239] = true, -- Cured Leather Gloves
    [237] = true, -- Cured Leather Pants
    [851] = true, -- Cutlass
    [922] = true, -- Dacian Falx
    [5110] = true, -- Dalaran Wizard's Robe
    --    [13896]      = true,     -- Dark Green Wedding Hanbok
    [5108] = true, -- Dark Iron Leather
    [2315] = true, -- Dark Leather Boots
    [2316] = true, -- Dark Leather Cloak
    --    [19295]      = true,     -- Darkmoon Flower
    --    [6366]      = true,     -- Darkwood Fishing Pole
    [3137] = true, -- Deadly Throwing Axe
    [3295] = true, -- Deadman Blade
    [3293] = true, -- Deadman Cleaver
    [3294] = true, -- Deadman Club
    [3296] = true, -- Deadman Dagger
    [6579] = true, -- Defender Spaulders
    [17183] = true, -- Dented Buckler
    [1166] = true, -- Dented Buckler
    [6182] = true, -- Dim Torch
    [2139] = true, -- Dirk
    [1835] = true, -- Dirty Leather Belt
    [210] = true, -- Dirty Leather Boots
    [1836] = true, -- Dirty Leather Bracers
    [714] = true, -- Dirty Leather Gloves
    [209] = true, -- Dirty Leather Pants
    [85] = true, -- Dirty Leather Vest
    [7351] = true, -- Disciple's Boots
    [7350] = true, -- Disciple's Bracers
    [6514] = true, -- Disciple's Cloak
    [6515] = true, -- Disciple's Gloves
    [6513] = true, -- Disciple's Sash
    [927] = true, -- Double Axe
    [2499] = true, -- Double-bladed Axe
    [2613] = true, -- Double-stitched Robes
    [4314] = true, -- Double-stitched Woolen Shoulders
    [6836] = true, -- Dress Shoes
    [7094] = true, -- Driftwood Branch
    [1384] = true, -- Dull Blade
    [1201] = true, -- Dull Heater Shield
    [14384] = true, -- Durability Boots
    [14394] = true, -- Durability Bow
    [14385] = true, -- Durability Cloak
    [14387] = true, -- Durability Gloves
    [14386] = true, -- Durability Hat
    [14393] = true, -- Durability Shield
    [14392] = true, -- Durability Staff
    [14391] = true, -- Durability Sword
    [5211] = true, -- Dusk Wand
    [7809] = true, -- Easter Dress
    [19028] = true, -- Elegant Dress
    --    [2310]      = true,     -- Embossed Leather Cloak
    --    [4239]      = true,     -- Embossed Leather Gloves
    [2435] = true, -- Embroidered Armor
    [3587] = true, -- Embroidered Belt
    [2438] = true, -- Embroidered Boots
    [3588] = true, -- Embroidered Bracers
    [2440] = true, -- Embroidered Gloves
    [3892] = true, -- Embroidered Hat
    [2437] = true, -- Embroidered Pants
    [11199] = true, -- Engineer's Shield 1
    [11200] = true, -- Engineer's Shield 2
    [11201] = true, -- Engineer's Shield 3
    [2024] = true, -- Espadon
    [2528] = true, -- Falchion
    [3335] = true, -- Farmer's Broom
    [3334] = true, -- Farmer's Shovel
    [4190] = true, -- Feathered Armor
    [4195] = true, -- Feathered Boots
    [4194] = true, -- Feathered Bracers
    [15313] = true, -- Feral Shoulder Pads
    [21154] = true, -- Festival Dress
    [21542] = true, -- Festival Suit
    [4246] = true, -- Fine Leather Belt
    [2307] = true, -- Fine Leather Boots
    [15808] = true, -- Fine Light Crossbow
    [4560] = true, -- Fine Scimitar
    [6202] = true, -- Fingerless Gloves
    [997] = true, -- Fire Sword of Crippling
    --    [6256]      = true,     -- Fishing Pole
    [925] = true, -- Flail
    [2521] = true, -- Flamberge
    [766] = true, -- Flanged Mace
    [47] = true, -- Footpad's Shoes
    [13895] = true, -- Formal Dangui
    [2530] = true, -- Francisca
    [2067] = true, -- Frostbit Staff
    [2109] = true, -- Frostmane Chain Vest
    [2259] = true, -- Frostmane Club
    [2260] = true, -- Frostmane Hand Axe
    [2108] = true, -- Frostmane Leather Vest
    [2258] = true, -- Frostmane Shortsword
    [2257] = true, -- Frostmane Staff
    [3323] = true, -- Ghostly Bracers
    [1197] = true, -- Giant Mace
    [2488] = true, -- Gladius
    [15326] = true, -- Gleaming Throwing Axe
    [5209] = true, -- Gloom Wand
    [2030] = true, -- Gnarled Staff
    [18611] = true, -- Gnarlpine Leggings
    [1213] = true, -- Gnoll Kindred Bracers
    --    [6040]      = true,     -- Golden Scale Bracers
    [3321] = true, -- Gray Fur Booties
    [3546] = true, -- Gray Leather D02 Bracers
    [2531] = true, -- Great Axe
    --    [3835]      = true,     -- Green Iron Bracers
    [4308] = true, -- Green Linen Bracers
    --    [13900]      = true,     -- Green Wedding Hanbok
    [2582] = true, -- Green Woolen Vest
    [15302] = true, -- Grizzly Belt
    [15297] = true, -- Grizzly Bracers
    [15299] = true, -- Grizzly Cape
    [15300] = true, -- Grizzly Gloves
    [15301] = true, -- Grizzly Slippers
    [6525] = true, -- Grunt's Harness
    [5966] = true, -- Guardian Gloves
    [9752] = true, -- Gypsy Bands
    [9754] = true, -- Gypsy Cloak
    [9755] = true, -- Gypsy Gloves
    [9751] = true, -- Gypsy Sandals
    [9750] = true, -- Gypsy Sash
    [2028] = true, -- Hammer
    [2134] = true, -- Hand Axe
    [3661] = true, -- Handcrafted Staff
    [4237] = true, -- Handstitched Leather Belt
    [2302] = true, -- Handstitched Leather Boots
    [7277] = true, -- Handstitched Leather Bracers
    [7276] = true, -- Handstitched Leather Cloak
    [2303] = true, -- Handstitched Leather Pants
    [5957] = true, -- Handstitched Leather Vest
    [853] = true, -- Hatchet
    --    [6214]      = true,     -- Heavy Copper Maul
    [15809] = true, -- Heavy Crossbow
    [4307] = true, -- Heavy Linen Gloves
    [2448] = true, -- Heavy Pavise
    [3027] = true, -- Heavy Recurve Bow
    [15811] = true, -- Heavy Spear
    [3108] = true, -- Heavy Throwing Dagger
    [837] = true, -- Heavy Weave Armor
    [3589] = true, -- Heavy Weave Belt
    [3590] = true, -- Heavy Weave Bracers
    [839] = true, -- Heavy Weave Gloves
    [838] = true, -- Heavy Weave Pants
    [840] = true, -- Heavy Weave Shoes
    --    [3719]      = true,     -- Hillman's Cloak
    [2506] = true, -- Hornwood Recurve Bow
    [2511] = true, -- Hunter's Boomstick
    [4690] = true, -- Hunting Belt
    [2975] = true, -- Hunting Boots
    [3207] = true, -- Hunting Bracers
    [4689] = true, -- Hunting Cloak
    [8181] = true, -- Hunting Rifle
    [763] = true, -- Ice-covered Bracers
    [6509] = true, -- Infantry Belt
    [6506] = true, -- Infantry Boots
    [6507] = true, -- Infantry Bracers
    [6508] = true, -- Infantry Cloak
    [6510] = true, -- Infantry Gauntlets
    [2482] = true, -- Inferior Tomahawk
    [4700] = true, -- Inscribed Leather Spaulders
    [2207] = true, -- Jambiya
    [4663] = true, -- Journeyman's Belt
    [2959] = true, -- Journeyman's Boots
    [3641] = true, -- Journeyman's Bracers
    [4662] = true, -- Journeyman's Cloak
    [2960] = true, -- Journeyman's Gloves
    [18610] = true, -- Keen Machete
    [3107] = true, -- Keen Throwing Knife
    [2446] = true, -- Kite Shield
    [3602] = true, -- Knitted Belt
    [3603] = true, -- Knitted Bracers
    [793] = true, -- Knitted Gloves
    [794] = true, -- Knitted Pants
    [792] = true, -- Knitted Sandals
    [795] = true, -- Knitted Tunic
    [778] = true, -- Kobold Excavation Pick
    [1389] = true, -- Kobold Mining Mallet
    [1195] = true, -- Kobold Mining Shovel
    [2209] = true, -- Kris
    [2507] = true, -- Laminated Recurve Bow
    [2491] = true, -- Large Axe
    [3023] = true, -- Large Bore Blunderbuss
    [2480] = true, -- Large Club
    [2445] = true, -- Large Metal Shield
    [2129] = true, -- Large Round Shield
    [2486] = true, -- Large Stone Mace
    [1200] = true, -- Large Wooden Shield
    [19292] = true, -- Last Month's Mutton
    [19293] = true, -- Last Year's Mutton
    [15909] = true, -- Left-Handed Blades
    [15906] = true, -- Left-Handed Brass Knuckles
    [15907] = true, -- Left-Handed Claw
    [2398] = true, -- Light Chain Armor
    [2399] = true, -- Light Chain Belt
    [2401] = true, -- Light Chain Boots
    [2402] = true, -- Light Chain Bracers
    [2403] = true, -- Light Chain Gloves
    [2400] = true, -- Light Chain Leggings
    [15807] = true, -- Light Crossbow
    [2500] = true, -- Light Hammer
    [7281] = true, -- Light Leather Bracers
    [2110] = true, -- Light Magesmith Robe
    [2392] = true, -- Light Mail Armor
    [2393] = true, -- Light Mail Belt
    [2395] = true, -- Light Mail Boots
    [2396] = true, -- Light Mail Bracers
    [2397] = true, -- Light Mail Gloves
    [2394] = true, -- Light Mail Leggings
    [7026] = true, -- Linen Belt
    [2569] = true, -- Linen Boots
    [2570] = true, -- Linen Cloak
    [6201] = true, -- Lithe Boots
    [767] = true, -- Long Bo Staff
    [928] = true, -- Long Staff
    [3028] = true, -- Longbow
    [923] = true, -- Longsword
    [22279] = true, -- Lovely Black Dress
    [768] = true, -- Lumberjack Axe
    [2112] = true, -- Lumberjack Jerkin
    [15015] = true, -- Lupine Cloak
    [15013] = true, -- Lupine Cuffs
    [15019] = true, -- Lupine Mantle
    [852] = true, -- Mace
    [2526] = true, -- Main Gauche
    [20814] = true, -- Master's Throwing Dagger
    [924] = true, -- Maul
    [3331] = true, -- Melrache's Cape
    [2443] = true, -- Metal Buckler
    [17189] = true, -- Metal Buckler
    [2901] = true, -- Mining Pick
    [2532] = true, -- Morning Star
    [2898] = true, -- Mountaineer Chestpiece
    [14368] = true, -- Mystic's Shoulder Pads
    [14095] = true, -- Native Bands
    [14098] = true, -- Native Cloak
    [14102] = true, -- Native Handwraps
    [14110] = true, -- Native Sandals
    [14099] = true, -- Native Sash
    [948] = true, -- Nature Sword
    [51] = true, -- Neophyte's Boots
    [2508] = true, -- Old Blunderbuss
    [2509] = true, -- Ornate Blunderbuss
    [17190] = true, -- Ornate Buckler
    [2444] = true, -- Ornate Buckler
    [15505] = true, -- Outrunner's Pauldrons
    [2160] = true, -- Padded Armor
    [3591] = true, -- Padded Belt
    [2156] = true, -- Padded Boots
    [3592] = true, -- Padded Bracers
    [2158] = true, -- Padded Gloves
    [2159] = true, -- Padded Pants
    [14157] = true, -- Pagan Mantle
    [8182] = true, -- Pellet Rifle
    [2481] = true, -- Peon Sword
    [3332] = true, -- Perrine's Boots
    [5347] = true, -- Pestilent Wand
    [6517] = true, -- Pioneer Belt
    [6518] = true, -- Pioneer Boots
    [6519] = true, -- Pioneer Bracers
    [7109] = true, -- Pioneer Buckler
    [6520] = true, -- Pioneer Cloak
    [6521] = true, -- Pioneer Gloves
    [5238] = true, -- Pitchwood Wand
    [2057] = true, -- Pitted Defias Shortsword
    [2612] = true, -- Plain Robe
    [8094] = true, -- Platemail Armor
    [8088] = true, -- Platemail Belt
    [8089] = true, -- Platemail Boots
    [8090] = true, -- Platemail Bracers
    [8091] = true, -- Platemail Gloves
    [8092] = true, -- Platemail Helm
    [8093] = true, -- Platemail Leggings
    [2148] = true, -- Polished Scale Belt
    [2149] = true, -- Polished Scale Boots
    [2150] = true, -- Polished Scale Bracers
    [2151] = true, -- Polished Scale Gloves
    [2152] = true, -- Polished Scale Leggings
    [2153] = true, -- Polished Scale Vest
    [2505] = true, -- Polished Shortbow
    [2208] = true, -- Poniard
    [8177] = true, -- Practice Sword
    [15005] = true, -- Primal Bands
    [15003] = true, -- Primal Belt
    [15004] = true, -- Primal Boots
    [15006] = true, -- Primal Buckler
    [15007] = true, -- Primal Cape
    [15008] = true, -- Primal Mitts
    [3262] = true, -- Putrid Wooden Hammer
    [16037] = true, -- PVP Cloth Legs Horde
    [16036] = true, -- PVP Cloth Robe Horde
    [854] = true, -- Quarter Staff
    [2496] = true, -- Raider Shortsword
    [10407] = true, -- Raider's Shoulderpads
    [6147] = true, -- Ratty Old Belt
    [40] = true, -- Recruit's Boots
    [6122] = true, -- Recruit's Boots
    [3535] = true, -- Red Leather C03 Bracers
    [3419] = true, -- Red Rose
    [8624] = true, -- Red Sparkler
    [13899] = true, -- Red Traditional Hanbok
    [3026] = true, -- Reinforced Bow
    [2471] = true, -- Reinforced Leather Belt
    [2473] = true, -- Reinforced Leather Boots
    [2474] = true, -- Reinforced Leather Bracers
    [3893] = true, -- Reinforced Leather Cap
    [2475] = true, -- Reinforced Leather Gloves
    [2472] = true, -- Reinforced Leather Pants
    [2470] = true, -- Reinforced Leather Vest
    [2580] = true, -- Reinforced Linen Cape
    [17192] = true, -- Reinforced Targe
    [2442] = true, -- Reinforced Targe
    [4315] = true, -- Reinforced Woolen Shoulders
    [5187] = true, -- Rhahk'Zor's Hammer
    [15904] = true, -- Right-Handed Blades
    [15905] = true, -- Right-Handed Brass Knuckles
    [15903] = true, -- Right-Handed Claw
    [17188] = true, -- Ringed Buckler
    [2441] = true, -- Ringed Buckler
    [14126] = true, -- Ritual Amice
    [2614] = true, -- Robe of Apprenticeship
    [6206] = true, -- Rock Chipper
    [2026] = true, -- Rock Hammer
    [2065] = true, -- Rockjaw Blade
    [2282] = true, -- Rodentia Shortsword
    [2534] = true, -- Rondel
    [2483] = true, -- Rough Broad Axe
    [6350] = true, -- Rough Bronze Boots
    [2866] = true, -- Rough Bronze Cuirass
    [3480] = true, -- Rough Bronze Shoulders
    [10421] = true, -- Rough Copper Vest
    [1839] = true, -- Rough Leather Belt
    [796] = true, -- Rough Leather Boots
    [1840] = true, -- Rough Leather Bracers
    [797] = true, -- Rough Leather Gloves
    [798] = true, -- Rough Leather Pants
    [799] = true, -- Rough Leather Vest
    [2377] = true, -- Round Buckler
    [17185] = true, -- Round Buckler
    [13898] = true, -- Royal Dangui
    [2546] = true, -- Royal Frostmane Girdle
    [5254] = true, -- Rugged Spaulders
    [129] = true, -- Rugged Trapper's Boots
    --    [2857]      = true,     -- Runed Copper Belt
    [2854] = true, -- Runed Copper Bracers
    [3472] = true, -- Runed Copper Gauntlets
    [3593] = true, -- Russet Belt
    [2432] = true, -- Russet Boots
    [3594] = true, -- Russet Bracers
    [2434] = true, -- Russet Gloves
    [3889] = true, -- Russet Hat
    [2431] = true, -- Russet Pants
    [2429] = true, -- Russet Vest
    [2387] = true, -- Rusted Chain Belt
    [2389] = true, -- Rusted Chain Boots
    [2390] = true, -- Rusted Chain Bracers
    [2391] = true, -- Rusted Chain Gloves
    [2388] = true, -- Rusted Chain Leggings
    [2386] = true, -- Rusted Chain Vest
    [2497] = true, -- Rusted Claymore
    [1853] = true, -- Scalemail Belt
    [287] = true, -- Scalemail Boots
    [1852] = true, -- Scalemail Bracers
    [718] = true, -- Scalemail Gloves
    [286] = true, -- Scalemail Pants
    [285] = true, -- Scalemail Vest
    [3260] = true, -- Scarlet Initiate Robes
    [2027] = true, -- Scimitar
    [6588] = true, -- Scouting Spaulders
    [2128] = true, -- Scratched Claymore
    [2502] = true, -- Scuffed Dagger
    [4698] = true, -- Seer's Mantle
    [5404] = true, -- Serpent's Shoulders
    [945] = true, -- Shadow Sword
    [3135] = true, -- Sharp Throwing Axe
    [6566] = true, -- Shimmering Amice
    [2616] = true, -- Shimmering Silk Robes
    [3319] = true, -- Short Sabre
    [15810] = true, -- Short Spear
    [2132] = true, -- Short Staff
    [2131] = true, -- Shortsword
    [7050] = true, -- Silk Headband
    [2618] = true, -- Silver Dress Robes
    [3224] = true, -- Silver-lined Bracers
    [9744] = true, -- Simple Bands
    [10053] = true, -- Simple Black Dress
    [9745] = true, -- Simple Cape
    [9742] = true, -- Simple Cord
    [4565] = true, -- Simple Dagger
    [6786] = true, -- Simple Dress
    [9746] = true, -- Simple Gloves
    [10047] = true, -- Simple Kilt
    [10046] = true, -- Simple Linen Boots
    [10045] = true, -- Simple Linen Pants
    [9743] = true, -- Simple Shoes
    --  [3421]      = true,     -- Simple Wildflowers
    --  [7005]      = true,     -- Skinning Knife
    [2066] = true, -- Skull Hatchet
    [4302] = true, -- Small Green Dagger
    [2484] = true, -- Small Knife
    [17184] = true, -- Small Shield
    [2133] = true, -- Small Shield
    [1167] = true, -- Small Targe
    [17186] = true, -- Small Targe
    [2947] = true, -- Small Throwing Knife
    [2498] = true, -- Small Tomahawk
    [2055] = true, -- Small Wooden Hammer
    [2410] = true, -- Smoky Torch
    [5208] = true, -- Smoldering Wand
    [2114] = true, -- Snowy Robe
    [6549] = true, -- Soldier's Cloak
    [2510] = true, -- Solid Blunderbuss
    [4261] = true, -- Solliden's Trousers
    [4684] = true, -- Spellbinder Belt
    [2971] = true, -- Spellbinder Boots
    [3643] = true, -- Spellbinder Bracers
    [4683] = true, -- Spellbinder Cloak
    [2972] = true, -- Spellbinder Gloves
    [3328] = true, -- Spider Web Robe
    [3329] = true, -- Spiked Wooden Plank
    [2485] = true, -- Splintered Board
    [4951] = true, -- Squealer's Belt
    [43] = true, -- Squire's Boots
    [4263] = true, -- Standard Issue Shield
    --  [7922]      = true,     -- Steel Plate Helm
    [2494] = true, -- Stiletto
    [781] = true, -- Stone Gnoll Hammer
    [2268] = true, -- Stonesplinter Blade
    [5109] = true, -- Stonesplinter Rags
    --  [6365]      = true,     -- Strong Fishing Pole
    [2464] = true, -- Studded Belt
    [1913] = true, -- Studded Blackjack
    [2467] = true, -- Studded Boots
    [2468] = true, -- Studded Bracers
    [2463] = true, -- Studded Doublet
    [2469] = true, -- Studded Gloves
    [3890] = true, -- Studded Hat
    [6524] = true, -- Studded Leather Harness
    [2465] = true, -- Studded Pants
    [2327] = true, -- Sturdy Leather Bracers
    [1196] = true, -- Tabar
    [1843] = true, -- Tanned Leather Belt
    [843] = true, -- Tanned Leather Boots
    [1844] = true, -- Tanned Leather Bracers
    [844] = true, -- Tanned Leather Gloves
    [846] = true, -- Tanned Leather Jerkin
    [845] = true, -- Tanned Leather Pants
    [2754] = true, -- Tarnished Bastard Sword
    [2380] = true, -- Tarnished Chain Belt
    [2383] = true, -- Tarnished Chain Boots
    [2384] = true, -- Tarnished Chain Bracers
    [2385] = true, -- Tarnished Chain Gloves
    [2381] = true, -- Tarnished Chain Leggings
    [2379] = true, -- Tarnished Chain Vest
    [3595] = true, -- Tattered Cloth Belt
    [195] = true, -- Tattered Cloth Boots
    [3596] = true, -- Tattered Cloth Bracers
    [711] = true, -- Tattered Cloth Gloves
    [194] = true, -- Tattered Cloth Pants
    [193] = true, -- Tattered Cloth Vest
    [9444] = true, -- Techbot CPU Shell
    [3597] = true, -- Thick Cloth Belt
    [3598] = true, -- Thick Cloth Bracers
    [203] = true, -- Thick Cloth Gloves
    [201] = true, -- Thick Cloth Pants
    [202] = true, -- Thick Cloth Shoes
    [200] = true, -- Thick Cloth Vest
    [2121] = true, -- Thin Cloth Armor
    [3599] = true, -- Thin Cloth Belt
    [3600] = true, -- Thin Cloth Bracers
    [2119] = true, -- Thin Cloth Gloves
    [2120] = true, -- Thin Cloth Pants
    [2117] = true, -- Thin Cloth Shoes
    [6681] = true, -- Thornspike
    [4959] = true, -- Throwing Tomahawk
    [121] = true, -- Thug Boots
    [6138] = true, -- Thug Boots
    [6203] = true, -- Thuggish Shield
    [2490] = true, -- Tomahawk
    --  [2314]      = true,     -- Toughened Leather Armor
    [6127] = true, -- Trapper's Boots
    [4675] = true, -- Tribal Belt
    [3284] = true, -- Tribal Boots
    [3285] = true, -- Tribal Bracers
    [3649] = true, -- Tribal Buckler
    [4674] = true, -- Tribal Cloak
    [3286] = true, -- Tribal Gloves
    [2064] = true, -- Trogg Club
    [2787] = true, -- Trogg Dagger
    [2054] = true, -- Trogg Hand Axe
    [2524] = true, -- Truncheon
    --  [10036]      = true,     -- Tuxedo Jacket
    --  [10035]      = true,     -- Tuxedo Pants
    [4728] = true, -- Twain's Shoulder
    [20422] = true, -- Twilight Cultist Medallion of Station
    [2489] = true, -- Two-handed Sword
    [14083] = true, -- Tyrande's Staff
    [2979] = true, -- Veteran Boots
    [3213] = true, -- Veteran Bracers
    [4677] = true, -- Veteran Cloak
    [4678] = true, -- Veteran Girdle
    [3325] = true, -- Vile Fin Battle Axe
    [3327] = true, -- Vile Fin Oracle Staff
    [5767] = true, -- Violet Robes
    [2495] = true, -- Walking Stick
    [1202] = true, -- Wall Shield
    [2525] = true, -- War Hammer
    [2533] = true, -- War Maul
    [14728] = true, -- War Paint Shoulder Pads
    [2535] = true, -- War Staff
    [15482] = true, -- War Torn Bands
    [15483] = true, -- War Torn Cape
    [15480] = true, -- War Torn Girdle
    [15481] = true, -- War Torn Greaves
    [15484] = true, -- War Torn Handgrips
    [4772] = true, -- Warm Cloak
    [2967] = true, -- Warrior's Boots
    [3214] = true, -- Warrior's Bracers
    [3648] = true, -- Warrior's Buckler
    [4658] = true, -- Warrior's Cloak
    [4659] = true, -- Warrior's Girdle
    [2968] = true, -- Warrior's Gloves
    [1438] = true, -- Warrior's Shield
    [6148] = true, -- Web-covered Boots
    [3261] = true, -- Webbed Cloak
    [3263] = true, -- Webbed Pants
    --  [6837]      = true,     -- Wedding Dress
    [3131] = true, -- Weighted Throwing Axe
    [3008] = true, -- Wendigo Fur Cloak
    [2311] = true, -- White Leather Jerkin
    [8625] = true, -- White Sparkler
    --  [13897]      = true,     -- White Traditional Hanbok
    --  [10040]      = true,     -- White Wedding Dress
    [1965] = true, -- White Wolf Gloves
    [6787] = true, -- White Woolen Dress
    [15327] = true, -- Wicked Throwing Dagger
    [3322] = true, -- Wispy Cloak
    [3189] = true, -- Wood Chopper
    [2493] = true, -- Wooden Mallet
    [2501] = true, -- Wooden Warhammer
    [2584] = true, -- Woolen Cape
    [37] = true, -- Worn Axe
    [12282] = true, -- Worn Battleaxe
    [2092] = true, -- Worn Dagger
    --  [7996]      = true,     -- Worn Fishing Hat
    [2376] = true, -- Worn Heater Shield
    [36] = true, -- Worn Mace
    [2504] = true, -- Worn Shortbow
    [25] = true, -- Worn Shortsword
    [6447] = true, -- Worn Turtle Shell Shield
    [3606] = true, -- Woven Belt
    [2367] = true, -- Woven Boots
    [3607] = true, -- Woven Bracers
    [2369] = true, -- Woven Gloves
    [2366] = true, -- Woven Pants
    [2364] = true, -- Woven Vest
    [2529] = true -- Zweihander
    -- Add more item IDs as needed
}

-- Allow Magic Eraser to Delete these quest items if their associated quests are completed.
local AllowedDeleteQuestItems = {
    -- Example: [ItemID]     = {QuestID1, QuestID2, ...}
    [10515] = {3463}, -- Torch of Retribution
    [10575] = {4022, 4023}, -- Black Dragonflight Molt
    [11468] = {4286}, -- Dark Iron Fanny Pack
    [11725] = {4450}, -- Solid Crystal Leg Shaft
    [12533] = {4867}, -- Roughshod Pike
    [12534] = {4867}, -- Omokk's Head
    [12650] = {105, 211}, -- Attuned Dampener
    [12730] = {4867}, -- Warosh's Scroll
    [12738] = {5059}, -- Dalson Outhouse Key
    [12815] = {5097, 5098}, -- Beacon Torch
    [13289] = {5282}, -- Egan's Blaster
    [1358] = {138}, -- A Clue to Sander's Treasure
    [1361] = {139}, -- Another Clue to Sander's Treasure
    [1362] = {140}, -- Final Clue to Sander's Treasure
    [14544] = {5727},
    [16784] = {6563}, -- Sapphire of Aku'Mai
    [16991] = {6624, 6622}, -- Triage Bandage
    [17761] = {7067}, -- Gem of the First Khan
    [17762] = {7067}, -- Gem of the Second Khan
    [17763] = {7067}, -- Gem of the Third Khan
    [17764] = {7067}, -- Gem of the Fourth Khan
    [17765] = {7067}, -- Gem of the Fifth Khan
    [17781] = {7067}, -- The Pariah's Instructions
    [18501] = {5526}, -- Felvine Shard
    [19883] = {8201}, -- Sacred Cord
    [2154] = {231}, -- The Story of Morgan Ladimore
    [3248] = {253}, -- Translated Letter from The Embalmer
    [4472] = {656}, -- Scroll of Myzrael
    [4529] = {695}, -- Enchanted Agate
    [4614] = {635}, -- Pendant of Myzrael
    [4823] = {772},
    [4843] = {717}, -- Amethyst Runestone
    [4844] = {717}, -- Opal Runestone
    [4845] = {717}, -- Diamond Runestone
    [5088] = {894},
    [5165] = {905},
    [5251] = {944}, -- Phial of Scrying
    [5505] = {1023}, -- Teronis' Journal
    [5570] = {1069}, -- Deepmoss Egg
    [5884] = {1206}, -- Unpopped Darkmist Eye
    [6842] = {1701}, -- Furen's Instructions
    [6929] = {1712}, -- Bath'rah's Parchment
    [7442] = {2078}, -- Gyromast's Key
    [7666] = {2198}, -- Shattered Necklace
    [7667] = {2201}, -- Talvash's Phial of Scrying
    [7668] = {2201, 2339}, -- Bloodstained Journal
    [7846] = {2258, 2500}, -- Crag Coyote Fang
    [7907] = {2282}, -- Certificate of Thievery
    [8046] = {2359}, -- Kearnen's Journal
    [8047] = {17, 2202}, -- Magenta Fungus Cap
    [9279] = {2930}, -- White Punch Card
    [9309] = {2928}, -- Robo-mechanical Guts
    [9326] = {2945}, -- Grime-Encrusted Ring
    -- TODO
    -- Check for items like [Owatanka's Tailspike] that are not available to your current race, and discard if found.
}

-- Function to check if the player has completed any quest in the list
local function IsAnyQuestCompleted(questIDs)
    for _, questID in ipairs(questIDs) do
        if C_QuestLog.IsQuestFlaggedCompleted(questID) then
            return true
        end
    end
    return false
end

-- Function to check if the item is a consumable and its use level is within the allowed range
local function IsConsumableAndLevelAllowed(itemID)
    local useLevel = select(5, GetItemInfo(itemID)) -- Get the required level to use the item
    if useLevel and useLevel > 0 then
        local playerLevel = UnitLevel("player")
        return (playerLevel - useLevel >= 10)
    end
    return true -- If no use level is found, consider it allowed
end

-- Function to delete the lowest value gray item or specified deletable item (or stack) in the player's bag
local function DeleteLowValue()
    local lowestValue, lowestBag, lowestSlot = nil, nil, nil
    local lowestItemLink, lowestStackCount = nil, nil

    -- First, try to find quest items for completed quests
    for bag = 0, 4 do
        local numSlots = C_Container.GetContainerNumSlots(bag)
        for slot = 1, numSlots do
            local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
            if itemInfo and itemInfo.hyperlink then
                local itemID = itemInfo.itemID
                -- Check if the item is a quest item and any of its associated quests are completed
                if AllowedDeleteQuestItems[itemID] and IsAnyQuestCompleted(AllowedDeleteQuestItems[itemID]) then
                    C_Container.PickupContainerItem(bag, slot)
                    DeleteCursorItem()

                    print(
                        string.format(
                            "|cff00B0FFMagic Eraser|r : Erasing %s! This item was associated with a quest you have completed.",
                            itemInfo.hyperlink
                        )
                    )
                    return -- Stop after deleting a quest item
                end
            end
        end
    end

    -- If no quest items were found, fall back to deleting the lowest value gray or allowed item
    for bag = 0, 4 do
        local numSlots = C_Container.GetContainerNumSlots(bag)
        for slot = 1, numSlots do
            local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
            if itemInfo and itemInfo.hyperlink then
                local itemLink = itemInfo.hyperlink
                local stackCount = itemInfo.stackCount
                local itemID = itemInfo.itemID
                local _, _, itemRarity, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(itemLink)

                -- Check if it's a gray item or in AllowedDeleteItems
                if ((itemRarity == 0 and itemSellPrice > 0) or AllowedDeleteItems[itemID]) then
                    -- If it's a consumable, check the player's level against the item's use level
                    if not AllowedDeleteItems[itemID] or IsConsumableAndLevelAllowed(itemID) then
                        local totalValue = itemSellPrice * stackCount -- Total value of the stack
                        if not lowestValue or totalValue < lowestValue then
                            lowestValue = totalValue
                            lowestBag = bag
                            lowestSlot = slot
                            lowestItemLink = itemLink
                            lowestStackCount = stackCount
                        end
                    end
                end
            end
        end
    end

    if lowestBag and lowestSlot then
        -- Delete the lowest value item or stack
        C_Container.PickupContainerItem(lowestBag, lowestSlot)
        DeleteCursorItem()

        -- Convert copper to gold, silver, and copper
        local gold = math.floor(lowestValue / 10000)
        local silver = math.floor((lowestValue % 10000) / 100)
        local copper = lowestValue % 100

        -- Print the result with dynamic value formatting
        if gold > 0 then
            -- If the item is worth at least 1 gold
            print(
                string.format(
                    "|cff00B0FFMagic Eraser|r : Erasing %dx %s - worth %d|cffffd700g|r %d|cffc0c0c0s|r %d|cffcd7f32c|r.",
                    lowestStackCount,
                    lowestItemLink,
                    gold,
                    silver,
                    copper
                )
            )
        elseif silver > 0 then
            -- If the item is worth less than 1 gold but at least 1 silver
            print(
                string.format(
                    "|cff00B0FFMagic Eraser|r : Erasing %dx %s - worth %d|cffc0c0c0s|r %d|cffcd7f32c|r.",
                    lowestStackCount,
                    lowestItemLink,
                    silver,
                    copper
                )
            )
        else
            -- If the item is worth only copper (less than 1 silver)
            print(
                string.format(
                    "|cff00B0FFMagic Eraser|r : Erasing %dx %s - worth %d|cffcd7f32c|r.",
                    lowestStackCount,
                    lowestItemLink,
                    copper
                )
            )
        end
    else
        print(
            "|cff00B0FFMagic Eraser|r : Congratulations, your bags are full of good stuff! You'll have to manually erase something if you need to free up more space."
        )
    end
end

-- Slash command to run the function in-game
SLASH_DELETELOWGRAY1 = "/MagicEraser"
SlashCmdList["DELETELOWGRAY"] = DeleteLowValue
