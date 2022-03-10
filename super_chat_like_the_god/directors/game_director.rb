require_relative 'base'

module Directors
	# ゲーム本編のディレクター
	class GameDirector < Base
		CAMERA_ROTATE_SPEED_X = 0.01
		CAMERA_ROTATE_SPEED_Y = 0.01

		# 初期化
		def initialize(screen_width:, screen_height:, renderer:)
			super

			# ゲーム本編の次に遷移するシーンのディレクターオブジェクトを用意
			self.next_director = EndingDirector.new(screen_width: screen_width, screen_height: screen_height, renderer: renderer)

			# ゲーム本編の登場オブジェクト群を生成
			create_objects
			@total_score = 0
			@saisen_hit_count = 0

			# 弾丸の詰め合わせ用配列
			@bullets = []

			# 敵の詰め合わせ用配列
			@enemies = []

			# 現在のフレーム数をカウントする
			@frame_counter = 0

			@camera_rotate_x = 0.0
			@camera_rotate_y = 0.0

			@rot = 0
			@camera_rot_y=0

			cube_map_texture = Mittsu::ImageUtils.load_texture_cube(
 				 [ 'rt', 'lf', 'up', 'dn', 'bk', 'ft' ].map { |path|
    			"images/alpha-island_#{path}.png"
 			 }
			)

			shader = Mittsu::ShaderLib[:cube]
			shader.uniforms['tCube'].value = cube_map_texture

			skybox_material = Mittsu::ShaderMaterial.new({
  			fragment_shader: shader.fragment_shader,
  			vertex_shader: shader.vertex_shader,
  			uniforms: shader.uniforms,
  			depth_write: false,
  			side: Mittsu::BackSide
			})

			skybox = Mittsu::Mesh.new(Mittsu::BoxGeometry.new(100, 100, 100), skybox_material)
			self.scene.add(skybox)
		end

		# １フレーム分の進行処理
		def play
			# 地球を少しずつ回転させ、大気圏内を飛行してる雰囲気を醸し出す
			# @earth.rotate_x(0.002)

			# 現在発射済みの弾丸を一通り動かす
			@bullets.each(&:play)

			# 現在登場済みの敵を一通り動かす
			@enemies.each(&:play)

			# 各弾丸について当たり判定実施
			@bullets.each{|bullet| hit_any_enemies(bullet) }
			@bullets.each{|bullet| hit_saisen_box(bullet) }
			# 消滅済みの弾丸及び敵を配列とシーンから除去(わざと複雑っぽく記述しています)
			rejected_bullets = []
			@bullets.delete_if{|bullet| bullet.expired ? rejected_bullets << bullet : false }
			rejected_bullets.each{|bullet| self.scene.remove(bullet.mesh) }
			rejected_enemies = []
			@enemies.delete_if{|enemy| enemy.expired ? rejected_enemies << enemy : false }
			rejected_enemies.each{|enemy| self.scene.remove(enemy.mesh) }

			# 一定のフレーム数経過毎に敵キャラを出現させる
			if @frame_counter % 180 == 0
				x = rand(self.camera.position.x..@saisen.position.x)
				y = rand(self.camera.position.y..@saisen.position.y)
				z = rand(self.camera.position.z..@saisen.position.z)
				enemy = Enemy.new(x: x, y: y, z: z, saisen_position: @saisen.position, frame_counter: @frame_counter)
				@enemies << enemy
				self.scene.add(enemy.mesh)
			end

			@frame_counter += 1
			@camera_rot_y += 0.01 if self.renderer.window.key_down?(GLFW_KEY_UP)
			@camera_rot_y -= 0.01 if self.renderer.window.key_down?(GLFW_KEY_DOWN)
			self.camera.look_at(Mittsu::Vector3.new(@saisen.position.x,@saisen.position.y+@camera_rot_y,@saisen.position.z))

		#	self.camera.rotate_x(CAMERA_ROTATE_SPEED_X) if self.renderer.window.key_down?(GLFW_KEY_UP)
		#	self.camera.rotate_x(-CAMERA_ROTATE_SPEED_X) if self.renderer.window.key_down?(GLFW_KEY_DOWN)
		#	self.camera.rotate_y(CAMERA_ROTATE_SPEED_Y) if self.renderer.window.key_down?(GLFW_KEY_LEFT)
		#	self.camera.rotate_y(-CAMERA_ROTATE_SPEED_Y) if self.renderer.window.key_down?(GLFW_KEY_RIGHT)
			@rot -= 1 if self.renderer.window.key_down?(GLFW_KEY_LEFT)
			@rot += 1 if self.renderer.window.key_down?(GLFW_KEY_RIGHT)

			# ラジアンに変換する
			radian = (@rot * Math::PI) / 180
			# 角度に応じてカメラの位置を設定
			self.camera.position.x = 2*Math.sin(radian) + @saisen.position.x
			self.camera.position.z = 2*Math.cos(radian) + @saisen.position.z
		end

		# キー押下（単発）時のハンドリング
		def on_key_pressed(glfw_key:)
			case glfw_key
				# ESCキー押下でエンディングに無理やり遷移
				when GLFW_KEY_ESCAPE
					puts "シーン遷移 → EndingDirector"
					transition_to_next_director

				# SPACEキー押下で弾丸を発射
				when GLFW_KEY_SPACE
					shoot
			end
		end

		private

		# ゲーム本編の登場オブジェクト群を生成
		def create_objects
			# 太陽光をセット
			@sun = LightFactory.create_sun_light
			self.scene.add(@sun)

			# 地球を作成し、カメラ位置（原点）に対して大気圏を飛行してるっぽく見える位置に移動させる
			@saisen = Saisen.new
			@saisen.position.y = -0.8
			@saisen.position.z = -2.0
			self.scene.add(@saisen.mesh)
		end

		# 弾丸発射
		def shoot
			# 現在カメラが向いている方向を進行方向とし、進行方向に対しBullet::SPEED分移動する単位単位ベクトルfを作成する
			f = Mittsu::Vector4.new(0, 0, 1, 0)
			f.apply_matrix4(self.camera.matrix).normalize
			f.multiply_scalar(Bullet::SPEED)

			# 弾丸オブジェクト生成
			bullet = Bullet.new(f)
			self.scene.add(bullet.mesh)
			bullet.position.x=self.camera.position.x
			bullet.position.y=self.camera.position.y
			bullet.position.z=self.camera.position.z
			@bullets << bullet
		end

		# 弾丸と敵の当たり判定
		# 弾丸と敵の当たり判定
    def hit_any_enemies(bullet)
      return if bullet.expired

      @enemies.each do |enemy|
        next if enemy.expired
        distance = bullet.position.distance_to(enemy.position)
        if distance < 0.2
          puts "Hit!#{@total_score}"
          bullet.expired = true
          # enemy.expired = true
					@total_score -= 5

        end
      end
    end

    def hit_saisen_box(bullet)
      return if bullet.expired

      #賽銭箱のあたり判定と処理
      return if bullet.expired

      distance_saisen_bullet_x = (bullet.position.x - @saisen.position.x).abs
      distance_saisen_bullet_y = (bullet.position.y - @saisen.position.y).abs
			distance_saisen_bullet_z = (bullet.position.z - @saisen.position.z).abs
      if distance_saisen_bullet_x < 0.5 && distance_saisen_bullet_y < 0.5 && distance_saisen_bullet_z < 0.5
				@saisen_hit_count += 1
				bullet.expired = true
        puts("賽銭箱にあたったよ!!#{@saisen_hit_count.to_s}回目#{@total_score}")
        #当たった時の処理(点数加算とか)
				@total_score += 10
      end
    end
	end
end
