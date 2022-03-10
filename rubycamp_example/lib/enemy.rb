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
		y = -0.5

		pos = Mittsu::Vector3.new(x, y, z)
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
		dx = rand(3)
		dz = rand(3)
		case dx
		when 1
			self.mesh.position.x += 0.1
		when 2
			self.mesh.position.x -= 0.1
		end

		case dz
		when 1
			self.mesh.position.z += 0.1
		when 2
			self.mesh.position.z -= 0.1
		end
	end
end