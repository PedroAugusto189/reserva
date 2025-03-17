
class Recurso
  attr_accessor :id, :nome, :capacidade

  def initialize(id, nome, capacidade)
    @id = id
    @nome = nome
    @capacidade = capacidade
  end
end