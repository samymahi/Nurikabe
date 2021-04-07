

class Partie1v1 < Partie
  private_class_method :new

  ##
  # Creer un partie contre la montre en prenant en compte les sauvegardes
  def Partie1v1.creer(grille)
    new(grille)
  end

  ##
  # Constructeur de PartieContreLaMontre
  def initialize(grille) 
    super(grille)
  end

  ##
  # Renvoie le mode Contre la montre
  def getMode
      return Mode::VS
  end


  # ENLEVER LES AIDES PAYANTES 
  def partieTerminee?()
    term = @grilleEnCours.nbDifferenceBrut(@grilleBase)

    if(term == 0)
        socket = Fenetre1v1.getSocket
        if(socket != nil)
          mettrePause
          socket.puts ("ez" + Chrono.getTpsFormatPrecis(@chrono.time))
        else
            puts "aieTE"
        end
    end

    return term == 0
  end

  ##
  # A COMPLETER
  def verifierErreur(fromUser)#TOTEST
    return 0
  end   


  ##
  # A COMPLETER
  def ajouterCoup(coup)
     if(coup.couleur != coup.case.couleur && coup.couleur < Couleur::ILE_1) 
      coup.case.couleur = coup.couleur

      tabCoup.pop(tabCoup.size - @indiceCoup) #supprimer les coups annulés
      tabCoup.push(coup)
      @indiceCoup += 1

      FenetrePartie.getInstance.setAvancementSelf(@grilleEnCours.getPourcentage(@grilleBase, coup.case))
      socket = Fenetre1v1.getSocket
      if(socket != nil)
        socket.puts ("av" + @grilleEnCours.getPourcentage(@grilleBase, nil).to_s )
      else
          puts "aieAJ"
      end

      return true
    end
    return false
  end
  
  ##
  # A COMPLETER
  def revenirPositionBonne() #TOTEST
    self
  end

  ##
  # A COMPLETER
  def donneIndice()
    nil
  end

end
