class Coup
  private_class_method :new

  attr_reader :case, :couleur, :couleurBase

  ##
    # A COMPLETER
  def Coup.creer(case_, couleur, couleurBase)
    new(case_, couleur, couleurBase)
  end
  ##
  #Constructeur de Coup
  def initialize(case_, couleur, couleurBase)
    @case, @couleur, @couleurBase = case_, couleur, couleurBase
  end
end
