
class Reserva
  attr_accessor :id, :recurso_id, :nome_cliente, :email, :data_hora

  def initialize(id, recurso_id, nome_cliente, email, data_hora)
    @id = id
    @recurso_id = recurso_id
    @nome_cliente = nome_cliente
    @email = email
    @data_hora = data_hora
  end
end