# 敵キャラクタ
class Enemy
	attr_accessor :mesh, :expired

	# 初期化
	def initialize(x: nil, y: nil, z: nil, saisen_position: nil)
		# 初期位置指定が無ければランダムに配置する
#		x ||= rand(10) / 10.0 - 0.5
#		y ||= rand(10) / 10.0 + 1
#		z ||= rand(10) / 10.0 + 3
#			@earth.position.y = -0.9
#			@earth.position.z = -0.8
		@saisen_position = saisen_position
		r = rand(2.0..2.1)
		y = -0.5
		@dx = rand
		@dz = rand

		pos = Mittsu::Vector3.new(x, y, z)
		self.mesh = MeshFactory.create_enemy(radius_top: 0.0, color: 0x000000)
		self.mesh.position = pos
		self.expired = false
		@radian = 0
		@num = 1.5
	end

	# メッシュの現在位置を返す
	def position
		self.mesh.position
	end

	# 1フレーム分の進行処理
	def play

		@radian += 0.01
		@num += 0.001

		if @num > 2.5
			@num = 1.5
			self.mesh.position.x = @num*Math.sin(@radian) + @saisen_position.x + rand
			self.mesh.position.z = @num*Math.cos(@radian) + @saisen_position.z + rand
		end

		self.mesh.position.x = @num*Math.sin(@radian) + @saisen_position.x
		self.mesh.position.z = @num*Math.cos(@radian) + @saisen_position.z
		
		# dx = rand(3)
		# dz = rand(3)
		# case dx
		# when 1
		# 	self.mesh.position.x = @num*Math.sin(@radian) + @saisen_position.x + rand
		# when 2
		# 	self.mesh.position.x = 1.5*Math.sin(@radian) + @saisen_position.x - rand
		# end

		# case dz
		# when 1
		# 	self.mesh.position.z = 1.5*Math.cos(@radian) + @saisen_position.z + rand
		# when 2
		# 	self.mesh.position.z = 1.5*Math.cos(@radian) + @saisen_position.z - rand
		# end

		# if self.mesh.position.x >= 3.0 || self.mesh.position.x <= -3.0
		# 	self.mesh.position.x = rand(self.camera.position.x..@saisen.position.x)
		# end
		
		# if self.mesh.position.z >= 1.0 || self.mesh.position.z <= -5.0
		# 	self.mesh.position.z = rand(self.camera.position.z..@saisen.position.z)
		# end
		# if frame_counter % 190 == 0

		# if @frame_counter % 180 < 100
		# 	self.mesh.position.x -= 0.01
		# 	self.mesh.position.z -= 0.01
		# end

		# if @frame_counter % 180 == 0
		# 	puts self.mesh.position
		# end
		# else
		# 	self.mesh.position.x = @camera_position_x - self.mesh.position.x
		# 	self.mesh.position.z = @camera_position_z - self.mesh.position.z
		# end

	end

	# def coordinate_x
	# 	return @saisen_position.x
	# end

	# def coordinate_z
	# 	return @saisen_position.z
	# end

end