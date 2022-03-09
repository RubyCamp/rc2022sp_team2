class Saisen
  attr_accessor :mesh

  def initialize()
    self.mesh = MeshFactory.create_saisen
  end

  # メッシュの現在位置を返す
  def position
    self.mesh.position
  end

  # メッシュをリサイズ
  def resize(x,y,z)
    self.mesh.scale.x = x
    self.mesh.scale.y = y
    self.mesh.scale.z = z
  end

  def play
  end
end
