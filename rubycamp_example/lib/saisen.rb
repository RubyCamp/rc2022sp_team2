class Saisen
  attr_accessor :mesh

  def initialize()
    self.mesh = MeshFactory.create_saisen
  end

  # メッシュの現在位置を返す
  def position
    self.mesh.position
  end

  def play
	end
end
