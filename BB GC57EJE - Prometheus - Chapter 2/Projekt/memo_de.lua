memo_name =
"Notizblock"
memo_description =
"Im Notizblock wird festgehalten, was bisher geschehen ist."
memo_command_view_caption =
"Anschauen"

function save_game(entry)
    if entry then
        text_memo = string.format("%s\n---\n%s", entry, text_memo)
    end
    prometheus_chapter_2:RequestSync()
end

text_memo =
"Hier halte ich in umgekehrter chronologischer Reihenfolge wichtige Ereignisse fest. Ich kann im Übrigen extrem schnell schreiben! :-D Bei wichtigen Ereignissen wird das Spiel automatisch gespeichert und hier ein Eintrag gemacht."

text_event_01_previously =
"Ich hab das Virus unschädlich gemacht und John Greenwitch nicht an Mr. Johnson verkauft. Mr. Johnson ist mir dafür bestimmt böse und wird mir wohl auch die Konsequenzen meines Heldspielens aufzeigen, sollten wir uns je wieder begegnen. Allerdings ich habe da so ein Gefühl..."

text_event_04_call_from_johnson =
"Mr. Johnson rief mich an und wies mich auf einen Nachrichtenbeitrag hin. Das Virus breitet sich wohl schneller aus, als befürchtet. Johnson macht mich dafür verantwortlich und beauftragt mich, noch einmal mit John Greenwitch zu sprechen."

text_event_06a_call_from_johnson_daughter_abducted =
"\"... es geht um Greenwitchs Tochter. Er wird Ihre Hilfe benötigen!\" hat Johnson mir gesagt. Sollte ich Greenwitch davon berichten oder ist das nur einfache Panikmache?"

text_event_08_call_to_greenwitch_a_honest =
"Ich habe Greenwitch von Johnsons Anruf berichtet. Er will mich treffen."

text_event_08_call_to_greenwitch_b_hide =
"Ich habe mit John Greenwitch gesprochen, ihm aber verschwiegen, dass Johnson mich anrief. Greenwitch will mich treffen."

text_event_08_call_to_greenwitch_c_a06 =
"Ich habe Greenwitch von Johnsons Anruf berichtet und auch davon, dass es \"um seine Tochter ginge\". Greenwitch will mich treffen.\n2GHHJR"

text_event_10_shake_off_pursuers_first =
"Greenwitch hat mir plötzlich einen anderen Treffpunkt übermittelt. Ich sollte mich dort hin begeben. Und ich werde beobachtet. Ich sollte meine Verfolger so schnell wie möglich loswerden. Wahrscheinlich wird mir das nicht gleich beim ersten Versuch gelingen."

text_event_11_call_from_greenwitch_abduction =
"Greenwitchs Tochter Fiona wurde entführt. Er sandte mir einen Mitschnitt vom Anruf. Ich sollte mit den anhören, vielleicht gibt es ein paar Hinweise auf ihren Verbleib. Und ich sollte meine UV-Lampe bereithalten. Vielleicht hat gibt es irgendwelche Spuren ..."

text_event_11_call_from_greenwitch_abduction_known =
"Geahnt hatte ich es schon: Greenwitchs Tochter Fiona wurde entführt. Er sandte mir einen Mitschnitt vom Anruf. Ich sollte mir den anhören, vielleicht gibt es ein paar Hinweise auf ihren Verbleib. Und ich sollte meine UV-Lampe bereithalten. Vielleicht hat gibt es irgendwelche Spuren ..."

text_event_15_call_from_johnson_radio_tag =
"Mr. Johnson hat Fiona entführt, um meine Aufmerksamkeit zu erhalten. Die Spurensuche brachte mich zur Wohnung von einer Journalistin namens H. Onekana. Sie ist Patient 0, der Indexfall für Berlin. Sie liegt in Quarantäne und dürfte die Nacht wohl nicht überleben. Johnson redete mir ins Gewissen, dass wenn ich schon so einen Aufwand betreibe, Greenwitchs Tochter zu finden, dann sollte ich mir aber auch vor Augen führen, was passieren wird, wenn das Gegenmittel nicht in Masse produziert werden kann. Er hat Fiona mit einem Peilsender versehen und sie laufen lassen. Ich soll ihr unauffällig folgen. Johnson vermutet, sie trifft sich mit ihrem Vater."

text_event_17_call_from_johnson_stay =
"Fiona trifft ihren Vater. Johnson bedeutet mir stehen zu bleiben, damit die beiden nicht gewarnt werden. Ich könnte noch etwas näher ran gehen, wenn ich dem Gespräch zwischen den beiden lauschen möchte."

text_event_20a_johnson_kidnaps_greenwitch =
"Es geht alles sehr schnell. Ein schwarzer Van fährt vor und ein paar Gorillas in schicken Anzügen steigen aus und verwickeln Greenwitch in einen Faustkampf. Während seine Tochter Fiona fliehen kann, wird John ohnmächtig geschlagen und in den Van gezogen und abtransportiert. Ich kann nur hoffen, dass das Gegenmittel schnell synthetisiert und weltweit verbreitet wird."

text_event_21a_call_from_johnson_gratitude_traitors_end =
"Johnson ist mir dankbar und lässt mich das auch wissen. Er möchte mich einmal mehr für die Zeus Inc. rekrutieren. Ich denke, ich bin diesmal bereit dafür. Dazu soll ich mich an den toten Briefkasten begeben und in die Mitarbeiterliste eintragen."

text_event_21b_call_from_johnson_threat =
"Ich habe Greenwitch und seine Tochter gewarnt. Greenwitch gab mir daraufhin das Gegenmittel, das ich so schnell wie möglich zu seiner Kontaktperson im Krankenhaus bringen soll. Nun rief mich auch Johnson an und ließ mich wissen, wie gering er mich und meine Entscheidung achtet. Er hetzt seine Leute auf mich, um gewaltsam an das Gegenmittel zu kommen. Ich muss mich zum Krankenhaus beeilen."

text_event_23c_reaching_hospital_heroes_end =
"Ich hab Greenwitchs Kontakt, eine Ärztin, rechtzeitig treffen können. Mit dem Gegenmittel wird sie Frau Onekana retten können. Außerdem wird das Gegenmittel weiter synthetisiert, wobei das wohl tatsächlich nicht so schnell gehen wird, als wenn ein großer Konzern, wie Zeus Inc. das Gegenmittel bekommen hätte...\nIch soll mich zu einem toten Briefkasten begeben und mich dort in eine Liste von Troubleshootern eintragen, die dann gerufen werden können, wenn man sie später braucht."

text_event_23d_lost_antidote_to_johnson =
"Ich konnte Johnsons Schergen nicht entkommen. Plötzlich war ich von Gorillas in schicken Anzügen umzingelt. Sie nahmen mir nicht nur das Gegenmittel ab, sondern sorgten auch dafür, dass ich Johnsons Verachtung für mich für die nächsten Wochen nicht vergessen werde. Dennoch sollte ich zum Krankenhaus und ..."

text_event_24d_mourners_end =
"Ich konnte Greenwitchs Kontakt, einer Ärztin, kaum in die Augen schauen als ich ihr sagte, dass ich versagt habe. Sie meinte, dass Frau Onekana damit die Nacht nicht überleben wird. Ich sollte zumindest zum Friedhof gehen und mich ins Kondolenzbuch eintragen. Ein paar Worte sollte ich ihr zumindest hinterlassen ..."

text_event_completed_game =
"Ich habe dieses Abenteuer beendet."

text_event_completion_code =
"Completion Code"