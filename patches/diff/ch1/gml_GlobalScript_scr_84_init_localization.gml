11c11
<         _lang = (substr(_locale, 1, 2) != "ja") ? "en" : "ja";
---
>         _lang = (substr(_locale, 1, 2) == "en") ? "en" : ((substr(_locale, 1, 2) == "th") ? "th" : ((substr(_locale, 1, 2) == "ja") ? "ja" : "en"));
33c33
<             _lang = (substr(_locale, 1, 2) != "ja") ? "en" : "ja";
---
>             _lang = (substr(_locale, 1, 2) == "en") ? "en" : ((substr(_locale, 1, 2) == "th") ? "th" : ((substr(_locale, 1, 2) == "ja") ? "ja" : "en"));
85a86,151
>         }
>         if (global.lang == "th")
>         {
>             var fm = global.font_map;
>             ds_map_add(fm, "main", fnt_th_main);
>             ds_map_add(fm, "mainbig", fnt_th_mainbig);
>             ds_map_add(fm, "tinynoelle", fnt_th_main);
>             ds_map_add(fm, "dotumche", fnt_th_main);
>             ds_map_add(fm, "comicsans", fnt_th_tahomabold);
>             ds_map_add(fm, "small", fnt_small);
>             var sm = global.chemg_sprite_map;
>             ds_map_add(sm, "spr_bnamekris", spr_th_bnamekris);
>             ds_map_add(sm, "spr_bnameralsei", spr_th_bnameralsei);
>             ds_map_add(sm, "spr_bnamesusie", spr_th_bnamesusie);
>             ds_map_add(sm, "spr_btact", spr_th_btact);
>             ds_map_add(sm, "spr_btdefend", spr_th_btdefend);
>             ds_map_add(sm, "spr_btfight", spr_th_btfight);
>             ds_map_add(sm, "spr_btitem", spr_th_btitem);
>             ds_map_add(sm, "spr_btspare", spr_th_btspare);
>             ds_map_add(sm, "spr_bttech", spr_th_bttech);
>             ds_map_add(sm, "spr_darkmenudesc", spr_th_darkmenudesc);
>             ds_map_add(sm, "spr_dmenu_captions", spr_th_dmenu_captions);
>             ds_map_add(sm, "spr_quitmessage", spr_th_quitmessage);
>             ds_map_add(sm, "spr_thrashbody_b", spr_th_thrashbody_b);
>             ds_map_add(sm, "spr_thrashfoot_b", spr_th_thrashfoot_b);
>             ds_map_add(sm, "spr_thrashlogo", spr_thrashlogo);
>             ds_map_add(sm, "spr_thrashstats", spr_th_thrashstats);
>             ds_map_add(sm, "spr_fieldmuslogo", spr_fieldmuslogo);
>             var sndm = global.chemg_sound_map;
>             ds_map_add(sndm, "snd_joker_anything", snd_joker_anything);
>             ds_map_add(sndm, "snd_joker_chaos", snd_joker_chaos);
>             ds_map_add(sndm, "snd_joker_metamorphosis", snd_joker_metamorphosis);
>             ds_map_add(sndm, "snd_joker_neochaos", snd_joker_neochaos);
>         }
>         if (global.lang == "en")
>         {
>             var fm = global.font_map;
>             ds_map_add(fm, "main", fnt_main);
>             ds_map_add(fm, "mainbig", fnt_mainbig);
>             ds_map_add(fm, "tinynoelle", fnt_tinynoelle);
>             ds_map_add(fm, "dotumche", fnt_dotumche);
>             ds_map_add(fm, "comicsans", fnt_comicsans);
>             ds_map_add(fm, "small", fnt_small);
>             var sm = global.chemg_sprite_map;
>             ds_map_add(sm, "spr_bnamekris", spr_bnamekris);
>             ds_map_add(sm, "spr_bnameralsei", spr_bnameralsei);
>             ds_map_add(sm, "spr_bnamesusie", spr_bnamesusie);
>             ds_map_add(sm, "spr_btact", spr_btact);
>             ds_map_add(sm, "spr_btdefend", spr_btdefend);
>             ds_map_add(sm, "spr_btfight", spr_btfight);
>             ds_map_add(sm, "spr_btitem", spr_btitem);
>             ds_map_add(sm, "spr_btspare", spr_btspare);
>             ds_map_add(sm, "spr_bttech", spr_bttech);
>             ds_map_add(sm, "spr_darkmenudesc", spr_darkmenudesc);
>             ds_map_add(sm, "spr_dmenu_captions", spr_dmenu_captions);
>             ds_map_add(sm, "spr_quitmessage", spr_quitmessage);
>             ds_map_add(sm, "spr_thrashbody_b", spr_thrashbody_b);
>             ds_map_add(sm, "spr_thrashfoot_b", spr_thrashfoot_b);
>             ds_map_add(sm, "spr_thrashlogo", spr_thrashlogo);
>             ds_map_add(sm, "spr_thrashstats", spr_thrashstats);
>             ds_map_add(sm, "spr_fieldmuslogo", spr_fieldmuslogo);
>             var sndm = global.chemg_sound_map;
>             ds_map_add(sndm, "snd_joker_anything", snd_joker_anything);
>             ds_map_add(sndm, "snd_joker_chaos", snd_joker_chaos);
>             ds_map_add(sndm, "snd_joker_metamorphosis", snd_joker_metamorphosis);
>             ds_map_add(sndm, "snd_joker_neochaos", snd_joker_neochaos);
