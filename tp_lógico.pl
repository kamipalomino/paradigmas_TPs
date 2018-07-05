
miraSeries(Persona, Series).
miraSeries(juan, himym).
miraSeries(nico, starWars).
miraSeries(maiu, starWars).
miraSeries(gaston, hoc).
miraSeries(juan, futurama).
miraSeries(nico, got).
miraSeries(maiu, got).
miraSeries(juan, got).
miraSeries(maiu, onePiece).


personas(Persona):-
  miraSeries(Persona,_).

%Alf no ve ninguna serie porque el doctorado le consume toda la vida
%Alf no se define por no pertenecer a los que miran series. No hace falta negarlo

%himym, starWars, got, futurama, hoc, onePiece, drHouse, madMen.
quiereVer(Persona, Series).
quiereVer(juan, hoc).
quiereVer(aye, got).
quiereVer(gastón, himym).

sonPopulares(Series).
sonPopulares(hoc).
sonPopulares(got).
sonPopulares(starWars).

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

%miraOPlaneaVer que nos diga si una persona mira o planea ver una serie
miraOPlaneaVer(Persona, Serie):-
  miraSeries(Persona, Serie).
miraOPlaneaVer(Persona, Serie):-
  quiereVer(Persona, Serie).

leSpoileo(Sabe, NoLaVio, Serie):-
  miraOPlaneaVer(NoLaVio, Serie),
  leDijo(Sabe, NoLaVio, Serie, Spoiler),
  esSpoiler(Serie, Spoiler).

%  leSpoileo(Sabe, NoLaVio, Serie):-
 %   leDijo(Sabe, NoLaVio, Serie, Spoiler),
  %  esSpoiler(Serie, Spoiler),
   %   quiereVer(NoLaVio, Serie).

televidenteResponsable(Persona):-
  personas(Persona),
    not(leSpoileo(Persona, _, _)).
    
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
