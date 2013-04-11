require 'succubus'

# Generator which produces British tabloid newspaper-style sensationalist headlines
# Credit to Rachael Churchill, http://www.toothycat.net/wiki/wiki.pl?Rachael/TabloidHeadlineGenerator
module HeadlineGenerator
  Grammar = Succubus::Grammar.new do
    add_rule :base, "<headline1>", "<headline2>", "<headline3>", "<headline4>", "<headline5>", "<headline6>", "<headline4>", "<headline2>"

    add_rule :headline1, "<capperson> <verbphrases>", "<capperson> <verbphrases>", "<cappeople> <verbphrase>"
    add_rule :headline2, "<entity> told me to <verbphrase>, <verbsays> <person>", "<entity> told me to <verbphrase>, <verbsays> <personadjective> <person>"
    add_rule :headline3, "<summary> : <person> reveals all", "<summary> : <personadjective> <person> reveals all", "<summary> : <celebrity> reveals all", "<summary> : <personadjective> <celebrity> reveals all"
    add_rule :headline4, "<nouncause> can cause <effect>, <source>", "<nouncause> can cause <effect> in <victims>, <source>"
    add_rule :headline5, "<thing> found in <place>", "<deadperson> found living in <place>", "<entity> found in <place>"
    add_rule :headline6, "<capperson> in <person> <something> scandal", "<capperson> in <lcentity> <instrument> scandal", "<capperson> in <deadperson> <something> <badthing> scandal"

    add_rule :verbphrase, "<verb> <person> with <instrument>", "<verb> <number> <people> with <instrument>", "<verb> <celebrity> with <instrument>"
    add_rule :verbphrases, "<verbs> <person> with <instrument>", "<verbs> <number> <people> with <instrument>", "<verbs> <celebrity> with <instrument>", "<verbs> self with <instrument>", "finds Martians in <place>", "finds face of <deadperson> in <vegetable>"

    add_rule :summary, "My <adjective> affair with <celebrity>", "My <adjective> affair with <person>", "My <something> <badthing>"
    add_rule :badthing, "nightmare", "hell"
    add_rule :something, "alien abduction", "plastic surgery", "stalking", "drug", "cannibal", "speed-dating"
    add_rule :vegetable, "potato", "cauliflower", "lettuce", "pomegranate", "marrow", "turnip", "avocado"

    add_rule :adjective, "steamy", "torrid", "secret", "passionate", "sordid"
    add_rule :verbsays, "says", "claims", "alleges", "insists"

    add_rule :verb, "smite", "ritually dismember", "attack", "force-feed", "tickle", "spank", "scalp", "lobotomise", "gut", "eat", "stalk"
    add_rule :verbs, "smites", "ritually dismembers", "attacks", "force-feeds", "tickles", "spanks", "scalps", "lobotomises", "guts", "eats", "stalks"
    add_rule :instrument, "potato peeler", "steamroller", "cocktail stick", "vegetable", "pogo stick", "stick of rock", "tomahawk", "rattlesnake", "laser pointer"
    add_rule :personadjective, "distressed", "tragic", "terrified", "angry"

    add_rule :capperson, "Man", "Woman", "Cambridge student", "Mother of <number>", "Porn star", "Terrorist", "Paedophile", "Knife-wielding maniac", "Politician", "Escaped prisoner", "Driver"
    add_rule :person, "man", "woman", "Cambridge student", "mother of <number>", "porn star", "knife-wielding maniac", "politician", "escaped prisoner", "paedophile", "driver", "escaped prisoner"

    add_rule :cappeople, "Masked men", "Religious fundamentalists", "Cambridge students", "Terrorists"
    add_rule :people, "masked men", "religious fundamentalists", "Cambridge students", "terrorists"
    
    add_rule :number, "two", "four", "seven", "seventeen", "thirty-five"

    add_rule :nouncause, "Smoking", "Watching television", "Lack of exercise", "Unfiltered sunlight", "Eating GM food", "Eating British beef", "Sniffing solvents", "Long working hours", "Atkins diet", "Playing computer games"
    add_rule :effect, "death", "cancer", "impotence", "demon possession", "unwanted pregnancy", "AIDS", "hallucinations", "lasting psychological damage", "premature ageing", "obesity", "bubonic plague", "genetic mutation", "baldness", "bad breath"
    add_rule :victims, "women", "men", "teenagers", "infants", "over-50s", "guinea pigs", "rats", "monkeys", "vegetarians"
    add_rule :source, "study shows", "scientist claims", "new evidence reveals"

    add_rule :thing, "Turin shroud", "Cocaine", "Pornographic images", "Hostages", "Weapons of mass destruction", "Spy", "Crime boss", "Martian artefacts", "£1m diamond", "Giant tarantula", "Velociraptor egg"
    add_rule :place, "10 Downing Street", "Cheadle", "the White House", "<celebrity>'s home", "<celebrity>'s car", "Iraq", "London", "Trinity College"

    add_rule :entity, "God", "Angels", "Aliens", "Virgin Mary", "Demons", "Ghost of <deadperson>", "Ghost of <deadperson>", "Devil"
    add_rule :lcentity, "God", "angels", "aliens", "Virgin Mary", "demons", "ghost of <deadperson>", "ghost of <deadperson>", "devil"
    add_rule :deadperson, "Elvis", "Princess Diana", "Marilyn Monroe", "Kurt Cobain", "John Lennon", "Freddie Mercury", "James Dean", "Elvis", "Princess Diana", "Queen Victoria"

    add_rule :celebrity, "Beckham", "Michael Jackson", "David Blaine", "Su Pollard", "Bill Gates", "Prince William", "Britney", "Madonna", "J.Lo", "Maxine Carr", "Michael Moore", "Yootha Joyce", "Prince Philip", "Bush", "Blair", "Blunkett"
  end
end

if $0 == __FILE__
  loop do
    begin
      puts HeadlineGenerator::Grammar.execute(:base)
    rescue
    end
    gets
  end
end