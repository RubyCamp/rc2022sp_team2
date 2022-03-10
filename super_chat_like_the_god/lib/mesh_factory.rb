# メッシュオブジェクトのファクトリー
# ゲーム内に登場するメッシュを生産する役割を一手に引き受ける
class MeshFactory
	# 弾丸の生成
	def self.create_bullet(r: 0.1, div_w: 0.05, div_h: 0.05, color: nil, map: nil, normal_map: nil)
		geometry = Mittsu::CylinderGeometry.new(r, div_w, div_h)
		material = generate_material(:basic, color, map, normal_map)
		Mittsu::Mesh.new(geometry, material)
	end

		# 敵キャラクタの生成
		def self.create_enemy(radius_top: 0.1, radius_bottom: 0.2, div_h: 1.0, color: nil, map: nil, normal_map: nil)
			# 胴体の作成
			body_geometry = Mittsu::CylinderGeometry.new(radius_top, radius_bottom, div_h)
			material = generate_material(:basic, color, map, normal_map)
			mesh_body = Mittsu::Mesh.new(body_geometry, material)
			# 頭の作成
			head_geometry = Mittsu::SphereGeometry.new(radius_bottom)
			mesh_head = Mittsu::Mesh.new(head_geometry, material)
	
			mesh_head.position.y += 0.5
			
			mesh_body.add(mesh_head)
	
		end

	# 平面パネルの生成
	def self.create_panel(width: 1, height: 1, color: nil, map: nil)
		geometry = Mittsu::PlaneGeometry.new(width, height)
		material = generate_material(:basic, color, map, nil)
		Mittsu::Mesh.new(geometry, material)
	end

	# 地球の生成
	def self.create_saisen
		geometry = Mittsu::BoxGeometry.new(1, 1, 1)
		material = generate_material(
			:basic,
			nil,
			TextureFactory.create_texture_map("saisen2.png"),
			TextureFactory.create_normal_map("saisen2.png"))
		Mittsu::Mesh.new(geometry, material)
	end

	# 汎用マテリアル生成メソッド
	def self.generate_material(type, color, map, normal_map)
		mat = nil
		args = {}
		args[:color] = color if color
		args[:map] = map if map
		args[:normal_map] = normal_map if normal_map
		case type
		when :basic
			mat = Mittsu::MeshBasicMaterial.new(args)

		when :lambert
			mat = Mittsu::MeshLambertMaterial.new(args)

		when :phong
			mat = Mittsu::MeshPhongMaterial.new(args)
		end
		mat
	end
end
