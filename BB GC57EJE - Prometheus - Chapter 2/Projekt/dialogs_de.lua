dialog_scripts_language = "german"
groundspeak_access_key = "513893gmxnuf"

text_yes = "ja"
text_no = "nein"
text_accept = "annehmen"
text_reject = "ablehnen"
text_ignore_call = "Sie ignorieren den Anruf"
text_ok = "Okay"
text_incoming_call_johnson = "Anruf von Mr. Johnson"
text_incoming_call_greenwitch = "Anruf von Greenwitch"

--[[
DRAMATIS PERSONAE
Johnson                     - Matze
Greenwitch                  - Tobi
Fiona Greenwitch (Tochter)  - Regina
Nachrichtensprecher         - Mathi
Arzt                        - Anastasia
PATIENT_0                   - *** Keine Sprechrolle ***
--]]

character_john_greenwitch_name =
"John Greenwitch"

character_john_greenwitch_description =
"John Greenwitch ist ein Virologe und ehemaliger Mitarbeiter der Prometheus Corporation. Als Whistleblower deckte er die Verstrickungen seines Unternehmens um das Pandora-Virus auf. Er ist bislang auch weltweit der einzige Wissenschaftler, der ein stabiles Gegenmittel gegen das Virus entwickelt hat. Die Zeus Incorporated will seiner unbedingt habhaft werden."

character_fiona_greenwitch_name =
"Fiona Greenwitch"

character_fiona_greenwitch_description =
"Fiona ist die Tochter von John Greenwitch. Mr. Johnson hatte sie entführt, um an John Greenwitch heranzukommen."

character_mr_johnson_name =
"Mr. Johnson"

character_mr_johnson_description =
"Mr. Johnson arbeitet für die Zeus Incorporated, einem Konkurrenzunternehmen zur Prometheus Corporation. Er rekrutiert gern Laufburschen und möchte John Greenwitch davon überzeugen, für die Zeus Inc. zu arbeiten."

character_medical_doctor_name =
"Dr. WHO"

character_medical_doctor_description =
"Dr. WHO ist John Greenwitchs Kontaktperson und arbeitet für die Weltgesundheitsorganisation."


-- 1) ---
task_01_previously_name =
"Was bisher geschah ..."

task_01_previously_description =
"Sie können sich entweder eine Zusammenfassung vom Vorgänger (GC4CTGM) geben lassen oder gleich mit dem Spiel beginnen."

question_01_previously =
"Benötigen Sie eine Zusammenfassung von dem, was bisher geschah? Sie können sich die Zusammenfassung auch jederzeit noch einmal anschauen."

text_01_previously =
"Prometheus - Chapter 1: Projekt Pandora\ncoord.info/GC4CTGM\n\nVor ein paar Monaten wurde ich von einem Whistleblower namens John Greenwitch angesprochen. Er arbeitete als Virologe für die Prometheus Corporation. Als dort ein Projekt, an dem er arbeitete, außer Kontrolle geriet, musste er fliehen. Es ging um die Entwicklung eines Gegenmittels für ein Virus, von dem Greenwitch mutmaßte, dass es die Prometheus Corporation selbst erschaffen und irgendwo in Berlin freigesetzt hat. Greenwitch hatte irgendwo seine Aufzeichnungen versteckt und beauftragte mich, sie ihm zu besorgen, da er sich selbst versteckt halten musste. Kurz nachdem ich die Daten gefunden hatte und ihm übersandte, rief mich ein ominöser Mister Johnson von einer ebenso ominösen Zeus Incorporated an. Diese Firma scheint ein direkter Konkurrent zur Prometheus zu sein. Er beauftragte mich, Greenwitch an ihn auszuliefern, da dann bei der Zeus das Gegenmittel viel besser vervielfältigt werden könnte. Ich entschied mich gegen Johnson, was er mir wahrscheinlich noch immer übel nimmt. Stattdessen half ich Greenwitch, der mit Hilfe der Daten ein kurzlebiges Antidot synthetisieren konnte, was er auf das freigesetzte Virus ansetzen wollte. Da er abermals fliehen musste, hinterließ er mir das Antidot und ich musste das Virus neutralisieren, was mir auch gelang."

-- 2) JohnsonAnruf 1.1
text_02_call_from_johnson_1_1 =
"Ich grüße Sie! Sie erinnern sich sicher noch an mich! Johnson. Ich arbeite für die Zeus Inc. Wir hatten vor einiger Zeit die Ehre, uns kennen zu lernen. Es ging um das Virus, das die Prometheus Corp. freisetzen wollte. Ich hatte Ihnen meine Hilfe angeboten aber Sie haben abgelehnt.\nEs gibt da etwas, dass Sie sich ansehen sollten:"

-- 3) Nachrichtenbeitrag
item_03_news_name =
"Nachrichtenbeitrag"

text_03_news_link =
"http://youtu.be/le0_GkG7Hu8"

item_03_news_description =
"Nachrichtenbeitrag über die Ausbreitung des Virus\n" .. text_03_news_link

item_03_news_command_view_caption =
"Anschauen"

text_03_news =
"Link zum Nachrichtenbeitrag:\n" ..
text_03_news_link .. "\n\n" ..
"... auch von Seiten der WHO gibt man sich ratlos. Von den 8.000 dokumentierten Fällen in Ostafrika verliefen mehr als 90 Prozent tödlich.\nIn einer Pressekonferenz der WHO gab man bekannt, es werde nichts unversucht gelassen, ein Gegenmittel zu entwickeln. Experten schätzen, dass noch Monate vergehen werden, bis das Virus bekämpft werden kann.\nHeute Morgen gab das Ministerium für Gesundheit in Berlin eine erste bestätigte Infektion in Deutschland bekannt. Das Auswärtige Amt verschärfte darauf hin noch einmal seine Reisewarnungen für eine Vielzahl der afrikanischen und nun erstmalig auch süd-europäischen Staaten.\nBewahren Sie Ruhe!\nBleiben Sie wenn möglich zu Hause und halten Sie sich von Menschenmassen fern. Für den Fall, dass Sie Ihre Wohnung verlassen müssen, tragen Sie einen Mundschutz. Falls Sie Anzeichen von Übelkeit oder unerklärliche Blutungen haben, kontaktieren Sie umgehend den Rettungsdienst.\nDas Bundesministerium für Gesundheit hat für weitere Fragen unter 0176 81 90 83 61 eine Servicehotline eingerichtet ..."

-- 4) JohnsonAnruf 1.2
text_04_call_from_johnson_1_2 =
"Was Sie hier sehen, ist nur die Spitze des Eisbergs. Die Medien sprechen von weltweit weniger als 10.000 Infizierten. Doch glauben Sie mir, die tatsächlichen Zahlen sind weitaus größer. Es wird versucht, die Menschen mit banalen Sicherheitsvorschriften ruhig zu halten.\nAll das sind nur bequeme Lügen, um ihnen ein Gefühl von Sicherheit zu geben. Jeden Tag breitet sich das Virus schneller aus. Ein Heilmittel wird selbst von den optimistischsten Wissenschaftlern nicht in den nächsten Monaten erwartet.\nAber in einem Punkt haben die Medien Recht: Heute Morgen wurde der erste Patient in ein Berliner Krankenhaus eingeliefert. Morgen schon wird es vermutlich die nächsten Infizierten geben. Zunächst die Familie, dann Freunde, Nachbarn...\nIn den nächsten Wochen werden dutzende Menschen über unerklärliche Übelkeit klagen. Bald schon verspüren sie starken Husten, später unerklärliche Blutungen aus Mund, Nase und den Augen... Man wird sie ins Krankenhaus bringen, doch bis dahin haben sie wiederum Hunderte infiziert.\nMänner, Frauen, Kinder... sie alle werden sterben! Und alles nur, weil Sie den Helden spielen wollten.\nEs wird Zeit, dass Sie über die Konsequenzen Ihres Tuns nachdenken. Reden Sie noch einmal mit John Greenwitch! Er ist noch immer der Einzige, der bisher ein Gegenmittel erschaffen konnte. Wir brauchen ihn."

-- A5) -> A6) Johnson erzählt von Tochter
text_06a_call_from_johnson_daughter_abducted = {
"Ich habe Ihnen schon einmal nicht vertraut. Und ich vertraue Ihnen auch jetzt nicht!",
"Sie müssen mir nicht vertrauen. Aber es geht um John Greenwitchs Tochter. Er wird Ihre Hilfe benötigen!"
}

-- B5) -> B6) ---
text_05b_call_from_johnson =
"Alles klar, ich rede mit ihm!"

-- 7) ---
task_07_call_to_greenwitch_name =
"John Greenwitch anrufen"

task_07_call_to_greenwitch_description =
"Ich muss mit John Greenwitch sprechen"

-- 8) Anrufen bei Greenwitch. Er geht ans Telefon und sagt:
text_08_call_to_greenwitch =
"Sie sind es? Hmm... was für ein Zufall, dass Sie ausgerechnet jetzt anrufen. Worum geht es denn?"

-- A) Ehrlich -> Dankbar
text_08_call_to_greenwitch_a_honest = {
"Johnson hat mich gebeten, nach Ihnen zu schauen.",
"Ich hatte so etwas bereits befürchtet ..."
}

-- B) Verheimlichen -> Angepisst
text_08_call_to_greenwitch_b_hide = {
"Ich habe gehört, wir haben einen ersten Ausbruch in Deutschland. Zeit etwas zu unternehmen!",
"Das klingt, als wollten Sie noch über etwas anderes reden, aber gut ..."
}

-- C) Nach Tochter fragen (NUR wenn A6 gewählt wurde) -> Wird schweigsam
-- Da hab ich mal "Er hat Ihre Tocher" in "Es geht um Ihre Tochter" umgewandelt. Vielleicht nicht gleich mit der Entführung rausplatzen. Das kommt ja eh gleich nochmal!
text_08_call_to_greenwitch_c_a06 = {
"Johnson rief mich an. \"Es geht um Ihre Tochter\", meinte er ...",
"Verstehe. Wir sollten nicht am Telefon darüber reden!\n2GHHJR"
}

-- Antwort auf alles von John Greenwitch
text_08_call_to_greenwitch_end =
"Treffen Sie mich an den folgenden Koordinaten. Schnell!"

-- 9) ---

-- 10) In Zone - Anruf von Greenwitch (Komm zu anderer Zone)
-- TODO: ORT SPEZIFIZIEREN!
text_10_call_from_greenwitch_followed =
"Augen auf! Sie werden verfolgt. Es ist hier zu unsicher und ich brauche Sie ohnehin an einem anderen Ort. Kommen Sie so schnell wie möglich dort hin."

text_10_shake_off_pursuers_first =
"Zunächst muss ich meine Verfolger loswerden, bevor ich mich mit John Greenwitch treffen kann. Ich sollte diesen Ort erstmal verlassen und zurückkehren, wenn ich nicht mehr beobachtet werde."

text_10_no_pursuers_anymore =
"Ich denke ich habe meine Verfolger abgeschüttelt. Ich sollte mich schnell zum Treffpunkt mit Greenwitch begeben."

-- 11) Bei Punkt X: Anruf von Greenwitch.
-- John Greenwitch erzählt von Entführung, wenn der Spieler das
-- nicht weiß, oder es Greenwitch nicht erzählt hat.
text_11_call_from_greenwitch_abduction =
"Sehr gut. Ich glaube, es ist Ihnen niemand mehr gefolgt. Ich muss immer noch sehr vorsichtig sein. Vielleicht mehr denn je!\nAber ich habe den Punkt, an dem Sie sich befinden auch nicht zufällig gewählt. Es es geht um... Fiona... Meine Tochter. Sie wurde gestern von hier entführt. Und Johnson steckt dahinter.\nDieser Hund will mich dazu bringen, ihm die Forschungsdaten zu geben. Er will ein Gegenmittel, dass er teuer verkaufen kann.\nGott, ich hatte nicht gedacht, dass er zu so etwas im Stande wäre. Wie konnte ich nur so naiv sein?\nIch... ich erhielt einen Anruf von ihr kurz nach der Entführung. Ich sende Ihnen jetzt den Mitschnitt. Vielleicht hilft das, bei der Suche nach meiner Tochter.\nVersuchen Sie mit Ihrer UV-Lampe Spuren zu finden.\nHelfen Sie mir! Ich habe durch meine Arbeit schon ihre Mutter verloren. Ich kann nicht auch noch ohne meine Tochter leben. Ich bitte Sie! Bitte! Wenn nicht meinetwegen, dann um das Leben meiner Tochter zu schützen!"

-- Auch hier erzählt John Greenwitch von der Entführung, bezieht
-- sich aber auf darauf, dass der Spieler das schon weiß.
text_11_call_from_greenwitch_abduction_known =
"Sehr gut. Ich glaube, Ihnen ist niemand mehr gefolgt. Ich muss immer noch sehr vorsichtig sein. Mehr denn je! \nAber ich habe den Punkt, an dem Sie sich befinden auch nicht zufällig gewählt. Sie wissen ja, es es geht um Fiona... Meine Tochter. sie wurde gestern von hier entführt und - oh ja - raten sie mal, von wem! \n Johnson steckt dahinter.\nDieser Hund will mich dazu bringen, ihm die Forschungsdaten zu geben. Er will ein Gegenmittel, dass er teuer verkaufen kann.\nGott, ich hatte nicht gedacht, dass er zu so etwas im Stande wäre. Wie konnte ich nur so naiv sein? \nIch... ich erhielt einen Anruf von ihr kurz nach der Entführung. Ich sende Ihnen jetzt den Mitschnitt. Vielleicht hilft das, meine Tochter zu finden.\nVersuchen Sie mit Ihrer UV-Lampe Spuren zu finden. Vielleicht können Sie so meine Tochter aufspüren. Helfen Sie mir! Ich habe durch meine Arbeit schon ihre Mutter verloren. Ich kann nicht auch noch ohne meine Tochter leben. Ich bitte Sie! Bitte! Wenn nicht meinetwegen, dann um das Leben meiner Tochter zu schützen!"

-- 12) Item Telefonanruf
--[[
 (Ein Anruf von Johnson und Tochter):
 verrät ein paar Hinweise für Aufenthaltsort
--]]
item_12_call_from_johnson_abducted_daughter_name = 
"Mitschnitt von Fiona's Anruf"
item_12_call_from_johnson_abducted_daughter_description = 
"John Greenwitch hat den Anruf von Mr. Johnson an ihn, bei dem auch seine Tochter sprach, mitgeschnitten. Er hat mir diesen Mitschnitt zugesandt, da Fiona Hinweise auf ihren Aufenthaltsort genannt hat."
item_12_command_listen_caption =
"Anhören"

text_12_call_from_johnson_abducted_daughter =
"Papa? Bist Du da? Mir gehts gut, aber Du musst tun, was sie verlangen!\nHilf mir! Ich bin gleich bei den Brücken an der Bahn und da ist... Das reicht für's Erste. (... unterbricht Johnson den Anruf)"

-- 13) ---
task_13_find_fiona_name =
"Fiona finden"

task_13_find_fiona_description =
"Ich muss Fiona finden. Am besten suche ich nach Hinweisen bei den möglichen Aufenthaltsorten."

question_13_fionas_whereabouts =
"Ich muss herausfinden, wo sie festgehalten wird. Fiona erwähnte Brücken und die Bahn..."

input_13_fionas_whereabouts_wrong =
"Entweder ist der Hinweis falsch oder ich am falschen Ort..."

-- 14) Richtige Zone gefunden
text_14_call_from_johnson_right_zone =
"Nicht schlecht! Gar nicht schlecht! Sie haben meine Spur gefunden. Ich bin beeindruckt. Sie sind wirklich ein hervorragender Troubleshooter!\nEin Mensch mit außergewöhnlichen Fähigkeiten. Die Zeus Inc. benötigt immer Mitarbeiter wie Sie! Aber nein... das ist nicht der Grund für Ihre Anwesenheit. Und nein, es ist auch nicht John Greenwitchs Tochter. Oh bitte, keine Angst. Ihr geht es gut. Ich bin kein Unmensch!\nIch will Ihnen etwas zeigen! Darum, sagen Sie mir: wie klang John Greenwitch, als er Ihnen von seiner Tochter erzählte? Hat er gebettelt? Hat er gewinselt? Sehen Sie sich nur an! Sie geben ALLES um nur ein einziges Menschenleben zu retten. Ein Kind, welches noch nicht einmal Ihr eigenes ist!\nWeshalb tun Sie so etwas? Seinetwegen? Oder weil Sie Leben retten wollen? Glauben Sie mir, es stehen weit mehr Leben auf dem Spiel!\nNehmen Sie all sein Leid und all seine Sorgen und vertausendfachen Sie sie! Schon während wir reden, sterben Unschuldige. Nur, weil Sie den Helden spielen mussten! Können Sie nach all dem noch immer die alleinige Verantwortung dafür tragen?\nWissen Sie, ich habe Sie nicht ohne Grund an diesen Ort geführt. Hier in der Nähe wohnt Frau Onekana. 46 Jahre. Geschieden. Auslandskorrespondentin. Hat ein unehelichen Sohn... Eine ganz normale Frau. Bis auf eines... SIE ist die erste Infizierte. 'Patient 0'.\nZur Zeit liegt sie im Krankenhaus in Quarantäne. Die Ärzte geben ihr vielleicht noch einen Tag. Was schätzen Sie? Wie viele ihrer Nachbarn hat sie wohl bereits infiziert? Wie viele werden in den nächsten Wochen sterben? Und wie viele davon sind noch Kinder?\nVerstehen Sie mich nicht falsch! John Greenwitchs Tochter ist in Sicherheit. Ich habe sie gehen lassen. Alles was ich brauchte, war Ihre ungeteilte Aufmerksamkeit. Die habe ich jetzt. Ich gebe Ihnen noch eine weitere Gelegenheit, das Richtige zu tun. Sie müssen mir helfen. Sie müssen uns ALLEN helfen. Arbeiten Sie mit mir zusammen - es gibt noch mehr Eltern, die Angst um ihre Kinder haben..."

-- 15) Peilsender angebracht - neuer Auftrag
text_15_call_from_johnson_radio_tag =
"... ich habe Greenwitchs Tochter ohne ihr Wissen mit einem Peilsender versehen. Sie wird sich mit ihrem Vater treffen wollen. Das ist unsere Gelegenheit, das Ganze doch noch zu einem guten Ende zu bringen. Ich werde Ihr Telefon so modifizieren, dass Sie ihre Position sehen können. Für alles Weitere werde ich einen Funkkanal mit Ihnen offen halten. Folgen Sie ihr unauffällig und geben Sie mir Bescheid, wenn Sie Greenwitch gefunden haben! Er hat noch immer das Gegenmittel. Nun liegt alles an Ihnen! Einmal mehr. Treffen Sie Ihre Entscheidung! Unsere Zukunft liegt in Ihren Händen!"

-- 16) Tochter-Zone wandert
text_16_track_fiona =
"John Greenwitchs Tochter schaut sich nervös um. Wenn sie sich beobachtet fühlt, wird sie nicht zu ihrem Vater gehen. Besser ich folge ihr mit etwas Abstand."

--[[
Wie machen wir das hier? Erst Johnson, dann der Dialog?
Dann müssen wir den nicht unterbrechen und 'ne Entscheidungslogik da rein quetschen.
Aber cooler wäre natürlich, wenn die sich unterhalten und dann Johnson sagt, dass die Jungs kommen!
Einfacher ist natürlich, den Dialog da zu haben und unten
2 Buttons "Eingreifen" und "Nicht eingreifen!" zu haben.
--]]

-- 17) Nachricht von Johnson. Er hat gemerkt, dass Fiona stehen geblieben ist.
text_17_call_from_johnson_stay =
"Sie ist stehen geblieben. Ich schätze, sie hat ihn getroffen. Ich schicke meine Leute los. In etwa 4 Minuten ist alles geschafft! Unternehmen Sie nichts, bis wir ihn haben und halten Sie Abstand! Ich möchte nicht, dass er gewarnt wird!"

-- 18) Tochter trifft John, Dialog der beiden
timeout_18_greenwitch_meets_daughter = {} 
text_18_greenwitch_meets_daughter = {}
--[[
Vorstop Spielzeit: 238 sekunden - Genug zum Handeln und noch einmal eine gute Zusammenfassung der "Verantwortung",
die der Spieler hier trägt. Mir gefällt der Dialog! :-)

(=> Sie hat Dich geliebt so wie ich Dich liebe!)
... joa ist recht herzschmerzig :)

-----------------------------------------------------------------------------------
--]]

text_18 = "Fiona trifft ihren Vater. Sie beginnen ein Gespräch."
function accumulate_text_18(next_argument)
    text_18 = string.format("%s\n---\n%s", next_argument, text_18)
end

-- Greenwitch:[überrascht]
timeout_18_greenwitch_meets_daughter[1] = 4
text_18_greenwitch_meets_daughter[1] =
"John Greenwitch:\n" ..
"Fio! Fiona? Bist Du das? Gott sei Dank! Bist Du verletzt?"

-- Fiona: 
timeout_18_greenwitch_meets_daughter[2] = 6
text_18_greenwitch_meets_daughter[2] =
"Fiona:\n" ..
"Oh gut, dass Du fragst. Mir geht es prima. Ich wurde nur mal eben entführt. Übrigens: Deinetwegen!"

-- Greenwitch:
timeout_18_greenwitch_meets_daughter[3] = 5
text_18_greenwitch_meets_daughter[3] =
"John Greenwitch:\n" ..
"Mein Gott, es tut mir Leid, mein Liebling! Verzeih mir! Es wird alles wieder gut! Ich verspreche es Dir!"

-- Fiona:
timeout_18_greenwitch_meets_daughter[4] = 3
text_18_greenwitch_meets_daughter[4] =
"Fiona:\n" ..
"Ich hasse es, wenn Du Dinge versprichst, die Du nicht halten wirst."

-- Greenwitch:
timeout_18_greenwitch_meets_daughter[5] = 12
text_18_greenwitch_meets_daughter[5] =
"John Greenwitch:\n" ..
"Fio, ich weiß, Du gibst mir die Schuld daran. Aber es war dieser Johnson. Er allein ist dafür verantwortlich. Eines Tages finde ich ihn. Und dann lasse ihn dafür bezahlen was er Dir angetan hat! DAS verspreche ich Dir!"

-- Fiona:
timeout_18_greenwitch_meets_daughter[6] = 4
text_18_greenwitch_meets_daughter[6] =
"Fiona:\n" ..
"Mag sein, dass er mich entführt hat. Aber was bitte hast Du getan, um mich da raus zu holen?"

-- Greenwitch:
timeout_18_greenwitch_meets_daughter[7] = 2
text_18_greenwitch_meets_daughter[7] =
"John Greenwitch:\n" ..
"Es ist bald vorbei!"

-- Fiona: 
timeout_18_greenwitch_meets_daughter[8] = 2
text_18_greenwitch_meets_daughter[8] =
"Fiona:\n" ..
"Was bitte soll das bedeuten?"

-- Greenwitch:
timeout_18_greenwitch_meets_daughter[9] = 12
text_18_greenwitch_meets_daughter[9] =
"John Greenwitch:\n" ..
"Ich habe das Gegenmittel bei mir. Ich muss es zum Krankenhaus bringen damit wir mehr davon herstellen können. Aber ich muss mich beeilen. Wir können niemandem trauen. Johnson wird alles tun, um es in seine Finger zu bekommen und wird er es verkaufen."

-- Fiona:
timeout_18_greenwitch_meets_daughter[10] = 3
text_18_greenwitch_meets_daughter[10] =
"Fiona:\n" ..
"Verdammt nochmal! Na und, dann soll er es doch verkaufen!"

-- Greenwitch:
timeout_18_greenwitch_meets_daughter[11] = 7
text_18_greenwitch_meets_daughter[11] =
"John Greenwitch:\n" ..
"Versteh doch, Fio. Er denkt nur an sein Geld. Aber das bekommt er nur, so lange er der Einzige ist, der das Gegenmittel produzieren kann."

timeout_18_greenwitch_meets_daughter[12] = 7
text_18_greenwitch_meets_daughter[12] =
"John Greenwitch:\n" ..
"So lange ich weiß, wie man es herstellt, wird er uns jagen.\nEs... es tut mir leid, dass ich Dich mit hineingezogen habe!"

-- Fiona: [zynisch] 
timeout_18_greenwitch_meets_daughter[13] = 6
text_18_greenwitch_meets_daughter[13] =
"Fiona:\n" ..
"Oh, gut! Er wird uns also umbringen! Das macht es natürlich viel besser! Glaubst Du, Mom hätte auch so gehandelt?"

-- Greenwitch:
timeout_18_greenwitch_meets_daughter[14] = 7
text_18_greenwitch_meets_daughter[14] =
"John Greenwitch:\n" ..
"Deine Mutter hat an das geglaubt, was wir getan haben. Was wir... was ICH immer noch tue! Sie glaubte an unsere Verantwortung."

-- Fiona:
timeout_18_greenwitch_meets_daughter[15] = 7
text_18_greenwitch_meets_daughter[15] =
"Fiona:\n" ..
"Ach ja? Hat sie vielleicht auch etwas über Verantwortung gegenüber der eigenen Familie gesagt? Ich glaube nicht, dass sie gerade stolz auf Dich wäre."

-- Greenwitch:
timeout_18_greenwitch_meets_daughter[16] = 9
text_18_greenwitch_meets_daughter[16] =
"John Greenwitch:\n" ..
"Du irrst Dich. Wenn Du Deine Mutter so gekannt hättest, wie ich sie damals kennen gelernt habe... Ach Gott, Du wüsstest, dass ihr alle Menschen wichtig waren. Für sie war Nächstenliebe keine Frage des Geldes."

timeout_18_greenwitch_meets_daughter[17] = 13
text_18_greenwitch_meets_daughter[17] =
"John Greenwitch:\n" ..
"Und sie hat sich niemals von denen abhalten lassen, die anders dachten. Deine Mutter war niemand, die einfach davon lief. Sie tat was sie für notwendig hielt. Auch wenn es bedeuten sollte, dass sie vielleicht niemals ihre eigene Tochter aufwachsen sehen würde."

-- Fiona: [wütend]
timeout_18_greenwitch_meets_daughter[18] = 11
text_18_greenwitch_meets_daughter[18] =
"Fiona:\n" ..
"Nein! Das geschah, weil Du nicht auf sie aufpassen konntest!\nSieh Dich nur an! Ich werde entführt und was tust Du? Statt nach Deiner eigenen Tochter zu suchen, rennst Du zum Krankenhaus um Gott zu spielen."

timeout_18_greenwitch_meets_daughter[19] = 10
text_18_greenwitch_meets_daughter[19] =
"Fiona:\n" ..
"Wenn es nach Dir ginge, wäre ich jetzt auch irgendwo wie ein Hund verscharrt. Ist es das, was Du willst? Bist Du erst zufrieden, wenn niemand mehr da ist? Damit Du in aller Ruhe 'die Welt retten' kannst?"

timeout_18_greenwitch_meets_daughter[20] = 12
text_18_greenwitch_meets_daughter[20] =
"Fiona:\n" ..
"Und später kannst Du jedem erzählen, was für ein Held Du warst! Welch furchtbaren Verlust Du dafür auf Dich nehmen musstest! Nein, Du machst es Dir zu leicht! DU ALLEIN bist Schuld an ihrem Tod!"

-- Greenwitch:
timeout_18_greenwitch_meets_daughter[21] = 8
text_18_greenwitch_meets_daughter[21] =
"John Greenwitch:\n" ..
"Was denn? Was? Glaubst Du ich würde sie nicht auch jeden Tag vermissen? Aber Du hast recht... vielleicht habe ich Fehler begangen. Wer weiß?"

timeout_18_greenwitch_meets_daughter[22] = 13
text_18_greenwitch_meets_daughter[22] =
"John Greenwitch:\n" ..
"Es vergeht kein Tag, an dem ich mir nicht selbst die Schuld für ihren Tod gebe. Aber wir müssen lernen, mit den Konsequenzen unserer Entscheidungen zu leben! Und genau deswegen können wir nicht einfach unsere Augen verschließen und hoffen, dass alles irgendwann wieder besser wird. Denn das wird es nicht!"

timeout_18_greenwitch_meets_daughter[23] = 7 
text_18_greenwitch_meets_daughter[23] =
"John Greenwitch:\n" ..
"Es wird immer nur schlimmer.\nWir müssen dafür kämpfen, was uns wichtig ist! Du bist das Wichtigste in meinem Leben, Fio! Immer!"

timeout_18_greenwitch_meets_daughter[24] = 14
text_18_greenwitch_meets_daughter[24] =
"John Greenwitch:\n" ..
"Und wir müssen uns bei jeder Entscheidung fragen, auf welcher Seite wir stehen und ob wir das Richtige tun.\nUnd irgendwann wenn all das hier vorüber ist, und Du auf diese Zeit zurückblickst, wirst Du vielleicht erkennen warum ich das hier tun musste. Auch wenn es schmerzt.\n\n" ..
"Fiona:\n" ..
"Papa!"

-- Fiona:
timeout_18_greenwitch_meets_daughter[25] = 3
text_18_greenwitch_meets_daughter[25] =
"Fiona:\n" ..
"Lass uns einfach weglaufen und ein normales Leben führen!"

-- Greenwitch:
timeout_18_greenwitch_meets_daughter[26] = 8
text_18_greenwitch_meets_daughter[26] =
"John Greenwitch:\n" ..
"Er wird uns finden. Er wird... mich... überall finden. Du hast Recht, ich habe Dich schon zu sehr in Gefahr gebracht!"

timeout_18_greenwitch_meets_daughter[27] = 8
text_18_greenwitch_meets_daughter[27] =
"John Greenwitch:\n" ..
"Es gibt nur eine Lösung. Du musst ohne mich fliehen. Lauf weg! Erzähl niemandem, wo Du bist. Nicht einmal mir. Und bleib dort, bis alles vorüber ist!\n\n" ..
"Fiona:\n" ..
"Nein!"

-- Fiona: [zitternd]
timeout_18_greenwitch_meets_daughter[28] = 5
text_18_greenwitch_meets_daughter[28] =
"Fiona:\n" ..
"Ich musste schon ohne Mutter aufwachsen. Ich kann nicht auch noch ohne Vater leben!"

-- Greenwitch:
timeout_18_greenwitch_meets_daughter[29] = 5
text_18_greenwitch_meets_daughter[29] =
"John Greenwitch:\n" ..
"Wenn ich nicht zu Ende bringe, was ich begonnen habe, werden noch viele Töchter ohne ihre Eltern aufwachsen müssen ..."

timeout_18_greenwitch_meets_daughter[30] = 2
text_18_greenwitch_meets_daughter[30] =
"John Greenwitch:\n" ..
"Die Menschen brauchen mich!"

-- Fiona:
timeout_18_greenwitch_meets_daughter[31] = 3
text_18_greenwitch_meets_daughter[31] =
"Fiona:\n" ..
"Niemand braucht Dich ...\n\n" ..
"John Greenwitch:\n" ..
"Ach Fio!\n\n" ..
"Fiona:\n" ..
"... Nein, hör mir zu!"

-- Fiona: 
timeout_18_greenwitch_meets_daughter[32] = 11
text_18_greenwitch_meets_daughter[32] =
"Fiona:\n" ..
"Niemand braucht Dich... so sehr wie ich! Aber... ich verstehe, warum Du das tun musst! Und Du tust das Richtige!"

-- Greenwitch:
timeout_18_greenwitch_meets_daughter[33] = 4
text_18_greenwitch_meets_daughter[33] =
"John Greenwitch:\n" ..
"Weißt Du, wie sehr Du Deiner Mutter in solchen Momenten ähnelst?"

timeout_18_greenwitch_meets_daughter[34] = 5
text_18_greenwitch_meets_daughter[34] =
"John Greenwitch:\n" ..
"Hach Gott, ich habe sie so geliebt ...\n\n" ..
"Fiona:\n" ..
"Ich liebe Dich, Papa!\n\n" ..
"John Greenwitch:\n" ..
"Ich liebe Dich auch, mein Engel!"

-- Greenwitch:
timeout_18_greenwitch_meets_daughter[35] = 3
text_18_greenwitch_meets_daughter[35] =
"John Greenwitch:\n" ..
"Ich werde nicht zulassen, dass Dir etwas zustößt ..."

-- 19
task_19_warn_greenwitch_or_wait_name =
"Entscheidung"
task_19_warn_greenwitch_or_wait_description =
"Ich muss mich entscheiden! Entweder ich gehe zu John Greenwitch unterbreche sein Gespräch mit seiner Tochter um ihn zu warnen, oder ich warte ab, und lasse zu, dass ihn Mr. Johnsons Agenten ergreifen."
text_19_warn_greenwitch =
"Warnen!"
text_19_cannot_warn_greenwitch =
"Ich muss zu Greenwitch hingehen, um ihn zu warnen."
text_19_cannot_warn_greenwitch_anymore =
"Es ist zu spät, um Greenwitch zu warnen."


--[[
-----------------------------------------------------------------------------------
Wenn nicht vorher "EINGREIFEN" geklickt wurde (und die Zeit um ist):

DER WAGEN KOMMT UND SCHNAPPT DIE BEIDEN (oder nur JOHN GREENWITCH???
Bleibt noch 'n offener Handlungsfaden, wenn sie in Teil 3 ggf. nach ihrem Vater sucht ...)
--]]

-- A19) ---
-- task_19_warn_greenwitch_or_wait -> "wait"

-- A20) ---

-- A21) Johnson ruft an und bedankt sich.
text_21a_call_from_johnson_gratitude_traitors_end =
"Sehr gut, sehr gut. Ich danke Ihnen. Ich muss gestehen, ich hatte Zweifel, wem Ihre Loyalität gilt. Es freut mich umso mehr, zu erkennen, dass sie der ganzen Menschheit gilt.\nVielleicht schon in wenigen Wochen werden wir eine erste Serie des Gegenmittels herstellen können. Effizienter als es jedes lokale Krankenhaus jemals schaffen würde. Dank Ihres Einsatzes werden tausende Leben gerettet.\nSie haben das Richtige getan und ich bin froh, Sie in meinem Team zu wissen. Ich weiß, was jetzt folgt wird nicht einfach. Aber gemeinsam können wir viel bewegen. Ich verlasse mich auf Sie! Wir haben da einen toten Briefkasten. Ich hoffe, Sie werden diesmal endgültig für uns arbeiten!"

-- ENDE VERRÄTER !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

-- B19) ---
-- task_19_warn_greenwitch_or_wait -> "warn"

-- B20) Greenwitch bedankt sich
--[[
Gibt Zusammenfassung über den Plan.
Gibt Spieler Gegenmittel und Task, ihn ins Krankenhaus zu bringen.
Reden Sie auf jeden Fall mit unserer Kontaktperson dort!
Er vernichtet den Peilsender und verschwindet.
--]]
text_20b_call_from_greenwitch_antidote =
"Sie hier? Ich verstehe. Danke!\nJohnson kann nicht weit sein. Ich vermute, die wissen bereits von meinem Plan. Mit Ihrer Hilfe bin ich zuversichtlich.\nDie suchen mich. Aber vielleicht nicht Sie...\nSie müssen dieses Gegenmittel zum Krankenhaus bringen. Passen Sie auf Johnsons Schergen auf. Wenn die Sie in die Finger kriegen, haben wir alles verloren.\nAber bedenken Sie, was es zu gewinnen gibt, wenn wir das Gegenmittel im Krankenhaus synthetisieren können. Wir werden Menschen retten! Also los, verlieren wir keine Zeit. Beeilen Sie sich!"

item_20b_minigame_rules_name =
"Minigame-Regeln"

item_20b_minigame_rules_description =
"Kurze Anleitung, wie man Mr. Johnsons Schergen ausweicht. ACHTUNG: Das Spiel wird dabei nicht pausiert!"

item_20b_minigame_rules_content =
"Zunächst eine allgemeine Information und eine Warnung: Die hier beschrieben Regeln kannst du dir jederzeit nochmal anschauen. ABER: Nur beim ersten Mal wird dabei auch das Spiel pausiert. Mr. Johnson hetzt seine Schergen auf dich und du musst denen ausweichen. Gelingt das nicht, ist das Gegengift verloren. Dieses Minispiel funktioniert mit bestimmten Arten von Zonen. Wir empfehlen daher, diesen Teil des Spiels ausschließlich mit der Karte zu spielen.\n\n" ..

"Umgebende Zone: Das ist die Spielfeldbegrenzung. Diese Zone ist am stärksten überwacht und darf auf gar keinen Fall betreten werden. Sie umgrenzt das den Bereich, in dem das Minispiel stattfindet.\n\n" ..

"Krankenhauszone: Diese Zone befindet sich etwa ein Kilometer im Osten. Du musst diese Zone unbeschadet erreichen und natürlich betreten, bevor die Schergen dich erwischen.\n\n" ..

"Fünfeckige Zone: Das ist ein Helikopter, der dir folgt. Er startet etwa eine Minute nachdem das Minigame beginnt. Falls er dich erreicht, du also innerhalb der fünfeckigen Zone bist, sucht er genauer und wenn er dich findet, hetzt er alle Vans auf dich. Du hast etwa eine Minute, diesen Suchbereich wieder zu verlassen. Der Helikopter wird dir nach einer Weile wieder folgen.\n\n" ..

"Rechteckige Zone: Dies ist eine Straßensperre bestehend aus schwarzen Vans. Diese Zone darfst du auf keinen Fall betreten.\n\n" ..

"Dreieckige Zone: Das ist ein patroullierender Agent, der nach dir sucht. Auch diese Zone darf auf keinen Fall betreten werden."

item_20b_command_view_caption =
"Anschauen"

task_20b_bring_antidote_to_hospital_name =
"Gegenmittel in Krankenhaus bringen"

task_20b_bring_antidote_to_hospital_description =
"Ich muss das Gegenmittel so schnell wie möglich ins Krankenhaus bringen. Johnsons Leute werden mir hinterher sein."

item_20_antidote_name =
"Gegenmittel"

item_20_antidote_description =
"Ein Gegenmittel-Prototyp. Er neutralisiert das Virus in seiner jetzigen Form. Doch es mutiert schnell und Johnsen ist mir auf den Fersen. Ich muss es so schnell wie möglich John Greenwitchs Kontaktperson im Krankenhaus übergeben, damit es in Massen synthetisiert werden kann."

-- B21) Nachricht von Johnson: Er schickt seine Schergen los!
text_21b_call_from_johnson_threat =
"Hmm, das verletzt mich... ich hatte gehofft, Sie wären ein Mensch, der aus seinen Fehlern lernen kann. Aber offenbar ist es Ihnen lieber, sich weiter als Rebell zu sehen.\nNun, ich habe Wichtigeres zu tun als mich mit einem Egoisten, wie Ihnen abzugeben. Bleiben Sie wo Sie sind und geben Sie das Gegenmittel einem meiner Agenten. Andernfalls muss ich Sie als Bedrohung der Zeus Inc. betrachten."

-- B22) Johnsons Schergen entkommen

-- C23) Im Krankenhaus angekommen
text_23c_reaching_hospital_heroes_end =
"Hey, hier drüben! Sind Sie der Troubleshooter? Ich hatte Greenwitch erwartet. Man kann niemandem mehr trauen. Haben Sie das Gegenmittel? Fantastisch! Ich werde mich gleich darum kümmern, es weiter zu synthetisieren. Wir retten Leben!\nIch weiß gar nicht, wie ich Ihnen genug danken kann. Aber es gibt keinen Grund unvorsichtig zu werden. Gerade jetzt müssen wir wachsam bleiben.\nDer alte tote Briefkasten ist zu unsicher geworden. Der neue befindet sich an den folgenden Koordinaten. Ach und noch etwas... Ich glaube, ich spreche auch im Namen von Frau Onekana. Sie retten ihr Leben: Danke! Man bekommt nicht oft eine zweite Chance!"

-- HELDEN ENDE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

-- D23) Johnsons Schergen nicht entkommen. Gegenmittel verloren

-- D24) Am Krankenhaus angekommen
--[[
Am Krankenhaus wartet eine Ärztin (in Person):
--]]
text_24d_reaching_hospital_mourners_end =
"Hey hier drüben! Was... Oh nein! Was ist passiert? Wie sehen Sie denn aus? Wo ist das Gegenmittel?\nOh, verflucht! Das war ihre einzige Chance! Sie wird die Nacht nicht überleben... Ich habe noch eine Bitte an Sie: Beten Sie für Frau Onekana.\nEs... es gibt da ein Kondolenzbuch. Sie hatte nicht viele Freunde aber vielleicht möchten Sie ja ein paar Worte für sie hinterlassen. Ein letzter Moment in stillem Gedenken, bevor wir - schon bald - noch viel dunkleren Zeiten entgegentreten ..."

-- ENDE TRAUERGÄSTE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

-- Completion Code
item_completion_code_name =
"Completion Code"
item_completion_code_description =
"Den Completion Code can man bei wherigo.com eingeben. Er ist für jeden Spieler eindeutig!"
item_completion_code_command_view_caption =
"Anzeigen"

-- Credits
item_credits_name =
"Credits"
item_credits_description =
"Wer hat GC57EJE realisiert?"
item_credits_command_view_caption =
"Credits zeigen"
item_credits_text =
"ENDE\n\n" ..
"Vielen Dank für das Durchspielen unseres Spiels. Wir hoffen ihr hattet eine Menge Spaß damit, denn eine Menge Leute haben Ihre Freizeit geopfert, um GC57EJE zu realisieren:\n\n" ..
"DRAMATIS PERSONAE\n\n" ..
"John Greenwitch\n. . . . . . . . . . . Dave\n\n" ..
"Fiona Greenwitch\n. . . . . . . . . . . Usurpatorchen\n\n" ..
"Mr. Johnson\n. . . . . . . . . . . Mahanako\n\n" ..
"Arzt\n. . . . . . . . . . . Anastasia Reich\n\n" ..
"Nachrichtensprecher\n. . . . . . . . . . . Mathias Reich\n\n" ..
"\n" ..
"STORY\n. . . . . . . . . . . Dave und Mahanako\n\n" ..
"KAMERA\n. . . . . . . . . . . Dave\n\n" ..
"PROGRAMMIERUNG\n. . . . . . . . . . . Mahanako"
