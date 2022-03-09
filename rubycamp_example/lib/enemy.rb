# 敵キャラクタ
class Enemy
	attr_accessor :mesh, :expired

	# 初期化
	def initialize(x: nil, y: nil, z: nil)
		# 初期位置指定が無ければランダムに配置する
#		x ||= rand(10) / 10.0 - 0.5
#		y ||= rand(10) / 10.0 + 1
#		z ||= rand(10) / 10.0 + 3
#			@earth.position.y = -0.9
#			@earth.position.z = -0.8

		r = rand(2.0..2.1)
		theta = rand(0..3.14)
		x = r*Math.cos( theta ) 
		y = -1.5
		z = r*Math.sin( theta ) + 0.8

		pos = Mittsu::Vector3.new(x, y, -z)
		self.mesh = MeshFactory.create_enemy(radius_top: 0.0, color: 0x000000)
		self.mesh.position = pos
		self.expired = false
	end

	# メッシュの現在位置を返す
	def position
		self.mesh.position
	end

	# 1フレーム分の進行処理
	def play
	end
end