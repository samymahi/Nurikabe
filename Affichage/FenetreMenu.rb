require_relative './Fenetre.rb'
require_relative './FenetreParametre.rb'
require_relative './FenetreAPropos.rb'
require_relative './FenetreClassement.rb'
require_relative './FenetrePartie.rb'
require_relative './Fenetre1v1.rb'
require_relative './FenetreSelection.rb'
require_relative "./../Partie/PartieSurvie.rb"
require_relative "./../Partie/PartieTuto.rb"
require_relative "./../Partie/PartieContreLaMontre.rb"

##
# Classe qui gère la création de l'interface de la fenetre du menu
# Herite de la classe Fenetre
class FenetreMenu < Fenetre

    ##
    # Methode pour l'initialisation
    def initialize()
        self
    end

    ##
    # Affiche la fenêtre de menu principal
    def self.afficheToi( _ ) #Pas de vue précédente
        Fenetre.set_subtitle(@@lg.gt("MENU"))
        Fenetre.add( FenetreMenu.new().creationInterface() )
        Fenetre.show_all
        return self
    end

    ##
    # Affiche une boite de dialogue contenant un message et pouvant répondre oui ou non (pour reprendre sauvegarde)
    def show_standard_message_dialog(unMessage)
        @dialog = Gtk::MessageDialog.new(:parent => @@window,
                                        :flags => [:modal, :destroy_with_parent],
                                        :type => :info,
                                        :buttons => :none,
                                        :message => unMessage)
        @dialog.add_button( @@lg.gt("OUI") , 0)
        @dialog.add_button( @@lg.gt("NON") , 1)
        response = @dialog.run
        @dialog.destroy
        return response
    end

    ##
    # Crée l'interface du menu principal
    def creationInterface()
        box = Gtk::Box.new(:vertical, 10)

        #Titre du jeu
        titre = Gtk::Label.new()
        titre.set_markup("<span weight = 'ultrabold' size = '90000' >Nurikabe</span>")
        box.add( setmargin(titre, 0, 0, 70, 70) )

        #Boutons du menu :

        #Bouton Libre
        btnLibre = Gtk::Button.new()
        setBold(btnLibre, @@lg.gt("LIBRE") )
        box.add( setmargin( btnLibre , 0, 15, 70, 70) )

        #Bouton Contre La Montre
        btnContreLaMontre = Gtk::Button.new()
        setBold(btnContreLaMontre, @@lg.gt("CONTRELAMONTRE") )
        box.add( setmargin( btnContreLaMontre , 0, 15, 70, 70) )

        #Bouton Survie
        btnSurvie = Gtk::Button.new()
        btnSurvie.set_height_request(60)


        boxSurvie = Gtk::Box.new(:horizontal)
        boxSurvie.set_homogeneous(true)
        boxSurvie.add( Gtk::Label.new(""))


        btnSurvieLabel = Gtk::Label.new()
        btnSurvieLabel.halign = :center
        btnSurvieLabel.set_markup("<span weight = 'ultrabold'>#{@@lg.gt("SURVIE")}</span>")
        boxSurvie.add( btnSurvieLabel )

        btnSurvieLabelStar = Gtk::Label.new("")
        btnSurvieLabelStar.name = "stars"
        boxSurvie.add( btnSurvieLabelStar )

        if Sauvegardes.getInstance.getSauvegardeScore.nbEtoiles < 5
            btnSurvie.set_sensitive(false)
            btnSurvieLabelStar.set_markup("<span weight = 'ultrabold'> #{ Sauvegardes.getInstance.getSauvegardeScore.nbEtoiles.to_s}/5 ★</span>")
        end

        btnSurvie.add( boxSurvie )
        box.add( setmargin( btnSurvie , 0, 15, 70, 70) )


        #Bouton 1v1
        btn1v1 = Gtk::Button.new()
        btn1v1.set_height_request(60)

        box1v1 = Gtk::Box.new(:horizontal)
        box1v1.set_homogeneous(true)
        box1v1.add( Gtk::Label.new(""))


        btn1v1Label = Gtk::Label.new()
        btn1v1Label.set_markup("<span weight = 'ultrabold'>#{@@lg.gt("1V1")}</span>")
        box1v1.add( btn1v1Label )

        btn1v1LabelStar = Gtk::Label.new("")
        btn1v1LabelStar.name = "stars"
        box1v1.add(  btn1v1LabelStar   )

        btn1v1.add(box1v1)
        box.add( setmargin( btn1v1 , 0, 15, 70, 70) )


        btnTutoriel = Gtk::Button.new()
        setBold(btnTutoriel, @@lg.gt("TUTORIEL") )
        box.add( setmargin( btnTutoriel , 0, 10, 70, 70) )

        if Sauvegardes.getInstance.getSauvegardeScore.nbEtoiles < 10
            btn1v1.set_sensitive(false)
            btn1v1LabelStar.set_markup("<span weight = 'ultrabold'>#{ Sauvegardes.getInstance.getSauvegardeScore.nbEtoiles.to_s}/10 ★</span>")

        end


        #Signaux


        btnLibre.signal_connect('clicked') {
            Fenetre.remove(box); FenetreSelection.afficheToi( FenetreMenu )
        }

        btnContreLaMontre.signal_connect('clicked') { |btn|
            #Affichage d'une pop up si une sauvegarde existe
            indice = Sauvegardes.getInstance.getSauvegardePartie.getIndicePartieSauvegarderContreLaMontre
            if(indice != -1)
                if (show_standard_message_dialog(@@lg.gt("REPRENDRE_SAUVEGARDE")) == 0)
                    Fenetre.remove(box);
                    FenetrePartie.afficheToiChargerPartie(FenetreMenu ,  indice)
                else
                    Sauvegardes.getInstance.getSauvegardePartie.supprimerSauvegardePartie(Sauvegardes.getInstance.getSauvegardePartie.getPartie(indice))
                end
            end
            creationHBoxCLM(box,2,btn,3,btnSurvie)
        }

        btnSurvie.signal_connect('clicked') { |btn|
           #Affichage d'une pop up si une sauvegarde existe
            indice = Sauvegardes.getInstance.getSauvegardePartie.getIndicePartieSauvegarderSurvie
            if(indice != -1)
                if (show_standard_message_dialog(@@lg.gt("REPRENDRE_SAUVEGARDE")) == 0)
                    Fenetre.remove(box);
                    FenetrePartie.afficheToiChargerPartie(FenetreMenu ,  indice)
                else
                    Sauvegardes.getInstance.getSauvegardePartie.supprimerSauvegardePartie(Sauvegardes.getInstance.getSauvegardePartie.getPartie(indice))
                end
            end
            creationHBoxSurvie(box,3,btn,2,btnContreLaMontre)
        }

        btn1v1.signal_connect("clicked"){
            Fenetre.remove(box);
            Fenetre1v1.afficheToi(FenetreMenu)
        }

        btnTutoriel.signal_connect('clicked') {
            Fenetre.remove(box);
            FenetrePartie.afficheToiSelec(FenetreMenu, PartieTuto.creer() )
        }

        #Separateur
        separateur = Gtk::Separator.new(:horizontal)
        box.add( setmargin(separateur, 0, 0, 80, 80) )

        #Bouton Classemet
        btnClassement = Gtk::Button.new(label: @@lg.gt("CLASSEMENT"))
        btnClassement.set_height_request(60)
        btnClassement.signal_connect('clicked') { Fenetre.remove(box); FenetreClassement.afficheToi( FenetreMenu ) }
        box.add( setmargin(btnClassement, 10, 10, 70, 70) )

        #Separateur
        separateur = Gtk::Separator.new(:horizontal)
        box.add( setmargin(separateur, 0, 0, 80, 80) )


        #Box contenant les boutons du bas
        hBox = Gtk::Box.new(:horizontal)
        hBox.set_homogeneous(true)

        #Bouton Paramètres
        btnParam = Gtk::Button.new(label: @@lg.gt("PARAMETRES"))
        setmargin(btnParam,0,0,0,5 )
        btnParam.set_height_request(50)
        btnParam.signal_connect('clicked') { Fenetre.remove(box); FenetreParametre.afficheToi( FenetreMenu ) }
        hBox.add(btnParam)

        #Bouton à propos
        btnAPropos = Gtk::Button.new(label: @@lg.gt("A_PROPOS"))
        setmargin(btnAPropos,0,0,0,5 )
        btnAPropos.signal_connect('clicked') { Fenetre.remove(box); FenetreAPropos.afficheToi( FenetreMenu ) }
        hBox.add(btnAPropos)

        #Bouton quitter
        btnQuitter = Gtk::Button.new(label: @@lg.gt("QUITTER"))
        btnQuitter.name = "btnQuitter"
        setmargin(btnQuitter,0,0,0,5 )
        btnQuitter.signal_connect("clicked") { Fenetre.exit }
        hBox.add(btnQuitter)

        box.add( setmargin(hBox, 10, 0, 70, 70) )

        @bbox = box
        return box
      end

    ##
    # Crée une boite de dialogue pour reprendre une partie en cours
    def creationHboxResumeGame( btn , mode , mainBox )
        box = Gtk::Box.new(:horizontal)
        btn.set_width_request(360)
        btn.set_margin_right(10)
        box.add(btn)
        btnResume = Gtk::Button.new(:label => @@lg.gt("REPRENDRE"));
        btnResume.set_width_request(180)
        btnResume.name = "resumeGame"

        if mode == Mode::SURVIE
            btnResume.signal_connect("clicked") { Fenetre.remove(mainBox); FenetrePartie.afficheToiChargerPartie(FenetreMenu , Sauvegardes.getInstance.getSauvegardePartie.getIndicePartieSauvegarderSurvie ) }
        elsif mode == Mode::CONTRE_LA_MONTRE
            btnResume.signal_connect("clicked") { Fenetre.remove(mainBox); FenetrePartie.afficheToiChargerPartie(FenetreMenu , Sauvegardes.getInstance.getSauvegardePartie.getIndicePartieSauvegarderContreLaMontre ) }
         end

        box.add(btnResume)
        return setmargin(box, 0, 15, 70, 70);
    end

    ##
    # Met des marges à un objet
    def setmargin(obj, top, bottom, left, right)
        obj.set_margin_top(top)
        obj.set_margin_bottom(bottom)
        obj.set_margin_left(left)
        obj.set_margin_right(right)
        return obj
    end

    ##
    # Methode qui permet de mettre en gras un label
    def setBold(btn, nom)
        label = Gtk::Label.new
        label.set_markup("<span weight = 'ultrabold'>#{nom}</span>")
        btn.add(label)
        btn.set_height_request(60)
    end

    ##
    # Methode qui permet de modifier l'affichage des bouton lorsque
    # l'utilisateur clique sur le bouton 'survie'.
    #
    # Le bouton se divise en 3 boutons ('facile', 'moyen' et 'difficile')
    def creationHBoxSurvie( box, position , remove , positionOtherDifficulty , btnOtherMode )

        if box.children[positionOtherDifficulty] != btnOtherMode
            box.remove( box.children[positionOtherDifficulty] )
            box.add(btnOtherMode)
            box.reorder_child(btnOtherMode, positionOtherDifficulty)
        end

        box.remove(remove) #DELETE

        hBox = Gtk::Box.new(:horizontal)
        hBox.set_height_request(60); hBox.set_homogeneous(true)
        hBox.add ( setmargin( Gtk::Button.new(),0,0,0,5 ) )
        hBox.add ( setmargin( Gtk::Button.new(),0,0,0,5 ) )
        hBox.add ( Gtk::Button.new() )

        # gestion des evenements des boutons de choix de niveau
        hBox.children[0].signal_connect("clicked"){
            Fenetre.remove(box);

            nbGrille = SauvegardeGrille.getInstance.getNombreGrille
            indiceRand = rand(1..(nbGrille/3))

            FenetrePartie.afficheToiSelec(FenetreMenu, PartieSurvie.creer(SauvegardeGrille.getInstance.getGrilleAt(indiceRand)))
        }
        hBox.children[1].signal_connect("clicked"){
            Fenetre.remove(box);

            nbGrille = SauvegardeGrille.getInstance.getNombreGrille
            indiceRand = rand((1+nbGrille/3)..(2*nbGrille/3))


            FenetrePartie.afficheToiSelec(FenetreMenu, PartieSurvie.creer(SauvegardeGrille.getInstance.getGrilleAt(indiceRand)))
        }

        hBox.children[2].signal_connect("clicked"){
            Fenetre.remove(box);

            nbGrille = SauvegardeGrille.getInstance.getNombreGrille
            indiceRand = rand((1+2*nbGrille/3)..nbGrille)

            FenetrePartie.afficheToiSelec(FenetreMenu, PartieSurvie.creer(SauvegardeGrille.getInstance.getGrilleAt(indiceRand)))
        }

        setBold( hBox.children[0] , @@lg.gt("FACILE") )
        setBold( hBox.children[1] , @@lg.gt("MOYEN") )
        setBold( hBox.children[2] , @@lg.gt("DIFFICILE") )

        box.add( setmargin(hBox,0,15,70,70) ) #ADD
        box.reorder_child( hBox , position  ) #REORDER
        Fenetre.show_all
    end

    ##
    # Methode qui permet de modifier l'affichage des bouton lorsque
    # l'utilisateur clique sur le bouton 'contre-la-montre'.
    #
    # Le bouton se divise en 3 boutons ('facile', 'moyen' et 'difficile')
    def creationHBoxCLM( box, position , remove , positionOtherDifficulty , btnOtherMode )

        if box.children[positionOtherDifficulty] != btnOtherMode
            box.remove( box.children[positionOtherDifficulty] )
            box.add(btnOtherMode)
            box.reorder_child(btnOtherMode, positionOtherDifficulty)
        end

        box.remove(remove) #DELETE

        hBox = Gtk::Box.new(:horizontal)
        hBox.set_height_request(60); hBox.set_homogeneous(true)
        hBox.add ( setmargin( Gtk::Button.new(),0,0,0,5 ) )
        hBox.add ( setmargin( Gtk::Button.new(),0,0,0,5 ) )
        hBox.add ( Gtk::Button.new() )

        # gestion des evenements des boutons de choix de niveau
        hBox.children[0].signal_connect("clicked"){
            Fenetre.remove(box);

            nbGrille = SauvegardeGrille.getInstance.getNombreGrille
            gridsId = (1..(nbGrille/3)).to_a.shuffle
            indiceRand = -1
            gridsId.each{ |id|
                if(Sauvegardes.getInstance.getSauvegardeScore.scoresContreLaMontre[id][1] == 0)
                    indiceRand = id
                    break
                end
            }

            if(indiceRand == -1 )
                gridsId.each{ |id|
                    if(Sauvegardes.getInstance.getSauvegardeScore.scoresContreLaMontre[id][1] == 1)
                        indiceRand = id
                        break
                    end
                }
            end

            if(indiceRand == -1 )
                gridsId.each{ |id|
                    if(Sauvegardes.getInstance.getSauvegardeScore.scoresContreLaMontre[id][1] == 2)
                        indiceRand = id
                        break
                    end
                }
            end

            if(indiceRand == -1 )
                indiceRand = gridsId[0]
            end


            FenetrePartie.afficheToiSelec(FenetreMenu, PartieContreLaMontre.creer(SauvegardeGrille.getInstance.getGrilleAt(indiceRand)))
        }
        hBox.children[1].signal_connect("clicked"){
            Fenetre.remove(box);


            nbGrille = SauvegardeGrille.getInstance.getNombreGrille
            gridsId = ((1 + nbGrille/3)..(2*nbGrille/3)).to_a.shuffle

            indiceRand = -1
            gridsId.each{ |id|
                if(Sauvegardes.getInstance.getSauvegardeScore.scoresContreLaMontre[id][1] == 0)
                    indiceRand = id
                    break
                end
            }

            if(indiceRand == -1 )
                gridsId.each{ |id|
                    if(Sauvegardes.getInstance.getSauvegardeScore.scoresContreLaMontre[id][1] == 1)
                        indiceRand = id
                        break
                    end
                }
            end

            if(indiceRand == -1 )
                gridsId.each{ |id|
                    if(Sauvegardes.getInstance.getSauvegardeScore.scoresContreLaMontre[id][1] == 2)
                        indiceRand = id
                        break
                    end
                }
            end

            if(indiceRand == -1 )
                indiceRand = gridsId[0]
            end



            FenetrePartie.afficheToiSelec(FenetreMenu, PartieContreLaMontre.creer(SauvegardeGrille.getInstance.getGrilleAt(indiceRand)))
        }

        hBox.children[2].signal_connect("clicked"){
            Fenetre.remove(box);


            nbGrille = SauvegardeGrille.getInstance.getNombreGrille
            gridsId = ((1 + 2*nbGrille/3)..nbGrille).to_a.shuffle

            indiceRand = -1
            gridsId.each{ |id|
                if(Sauvegardes.getInstance.getSauvegardeScore.scoresContreLaMontre[id][1] == 0)
                    indiceRand = id
                    break
                end
            }

            if(indiceRand == -1 )
                gridsId.each{ |id|
                    if(Sauvegardes.getInstance.getSauvegardeScore.scoresContreLaMontre[id][1] == 1)
                        indiceRand = id
                        break
                    end
                }
            end

            if(indiceRand == -1 )
                gridsId.each{ |id|
                    if(Sauvegardes.getInstance.getSauvegardeScore.scoresContreLaMontre[id][1] == 2)
                        indiceRand = id
                        break
                    end
                }
            end

            if(indiceRand == -1 )
                indiceRand = gridsId[0]
            end


            FenetrePartie.afficheToiSelec(FenetreMenu, PartieContreLaMontre.creer(SauvegardeGrille.getInstance.getGrilleAt(indiceRand)))
        }

        setBold( hBox.children[0] , @@lg.gt("FACILE") )
        setBold( hBox.children[1] , @@lg.gt("MOYEN") )
        setBold( hBox.children[2] , @@lg.gt("DIFFICILE") )

        box.add( setmargin(hBox,0,15,70,70) ) #ADD
        box.reorder_child( hBox , position  ) #REORDER
        Fenetre.show_all
    end
end

FenetreMenu.afficheToi( FenetreMenu )
Fenetre.show_all()

Gtk.main
