/mob/living/silicon/robot/drone/say(var/message)
	if(local_transmit)
		if (src.client)
			if(client.prefs.muted & MUTE_IC)
				src << "You cannot send IC messages (muted)."
				return FALSE
			if (src.client.handle_spam_prevention(message,MUTE_IC))
				return FALSE

		message = sanitize(message)

		if (stat == DEAD)
			return say_dead(message)

		if(copytext(message,1,2) == "*")
			return emote(copytext(message,2))

		if(copytext(message,1,2) == ";")
			var/datum/language/L = all_languages["Drone Talk"]
			if(istype(L))
				return L.broadcast(src,trim(copytext(message,2)))

		//Must be concious to speak
		if (stat)
			return FALSE

		var/list/listeners = hearers(5,src)
		listeners |= src

		for(var/mob/living/silicon/D in listeners)
			if(D.client && D.local_transmit)
				D << "<b>[src]</b> transmits, \"[message]\""

		for (var/mob/M in player_list)
			if (istype(M, /mob/new_player))
				continue
			else if(M.stat == DEAD && M.is_preference_enabled(/datum/client_preference/ghost_ears))
				if(M.client) M << "<b>[src]</b> transmits, \"[message]\""
		return TRUE
	return ..(message, 0)
