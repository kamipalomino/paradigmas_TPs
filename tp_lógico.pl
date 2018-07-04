
miraSeries(Persona, [Series]).
miraSeries(juan, [himym, futurama, got]).
miraSeries(nico, [starWars, got]).
miraSeries(maiu, [starWars, got, onePiece]).
miraSeries(gaston, [hoc]).
personas(Persona):-
  miraSeries(Persona,Serie).

%Alf no ve ninguna serie porque el doctorado le consume toda la vida
%Alf no se define por no pertenecer a los que miran series. No hace falta negarlo

%himym, starWars, got, futurama, hoc, onePiece, drHouse, madMen.
quiereVer(Persona, Series).
quiereVer(juan, hoc).
quiereVer(aye, got).
quiereVer(gastón, himym).

sonPopulares(hoc, got, starWars).

episodios(Serie, Temporada, Episodios).
episodios(got, 3, 12).
episodios(got, 2, 10).
episodios(himym, 1, 23).
episodios(drHouse, 8, 16).
episodios(madMen, 2).

%paso(Serie, Temporada, Episodio, Lo que paso)
paso(futurama, 2, 3, muerte(seymourDiera)).
paso(starWars, 10, 9, muerte(emperor)).
paso(starWars, 1, 2, relacion(parentesco, anakin, rey)).
paso(starWars, 3, 2, relacion(parentesco, vader, luke)).
paso(himym, 1, 1, relacion(amorosa, ted, robin)).
paso(himym, 4, 3, relacion(amorosa, swarley, robin)).
paso(got, 4, 5, relacion(amistad, tyrion, dragon)).

%leDijo/4
leDijo(gaston, maiu, got, relacion(amistad, tyrion, dragon)).
leDijo(nico, maiu, starWars, relacion(parentesco, vader, luke)).
leDijo(nico, juan, got, muerte(tyrion)).
leDijo(aye, juan, got, relacion(amistad, tyrion, john)).
leDijo(aye, maiu, got, relacion(amistad, tyrion, john)).
leDijo(aye, gaston, got, relacion(amistad, tyrion, dragon)).

esSpoiler(Serie, Spoiler):-   %es consulta existencial
  paso(Serie,_,_,Spoiler).

leSpoileo(Sabe, NoLaVio, Serie):-
  miraSeries(NoLaVio, Serie),
  leDijo(Sabe, NoLaVio, Serie, Spoiler),
  esSpoiler(Serie, Spoiler).

  leSpoileo(Sabe, NoLaVio, Serie):-
    leDijo(Sabe, NoLaVio, Serie, Spoiler),
    esSpoiler(Serie, Spoiler),
      quiereVer(NoLaVio, Serie).

televidenteResponsable(Persona):-
  personas(Persona),
    not(leSpoileo(Persona, Otro, Serie)).
    
seriesDeInterés(Serie):-
  cosasFuertes(Serie).

seriesDeInterés(Serie):-
  sonPopulares(Serie).
  
vieneZafando(Persona, Series):-
    seriesDeInterés(Series),
    quiereVer(Persona, Series),
    not(leSpoileo(Sabe, Persona, Series)),

  vieneZafando(Persona, Series):-
    seriesDeInterés(Series),
    miraSeries(Persona, Series),
    not(leSpoileo(Sabe, Persona, Series)).
