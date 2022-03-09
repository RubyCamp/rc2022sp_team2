module Directors
	# ディレクターの共通クラス
	class Base
		attr_accessor :scene, :camera, :renderer, :current_director, :next_director, :screen_width, :screen_height

		# 初期化
		def initialize(screen_width:, screen_height:, renderer:, fov: 75.0)
			# current_directorがデフォルトで自分自身を返すように設定
			self.current_director = self
			self.renderer = renderer

			# 画面解像度情報・アスペクト比を設定
			self.screen_width = screen_width
			self.screen_height = screen_height
			aspect = screen_width / screen_height.to_f

			# 当該ディレクターが扱うシーンとカメラを作成
			self.scene = Mittsu::Scene.new
			self.camera = Mittsu::PerspectiveCamera.new(fov, aspect, 0.1, 1000.0)
		end

		# 1フレーム分の進行処理
		# 子クラス側で必ずオーバーライドすることを前提とするので、ここでは例外を吐くようにしておく。
		def play
			raise 'override me.'
		end

		# キーボードのキー押下（単発）時のイベントハンドラ
		def on_key_pressed(glfw_key:)
		end

		# 次のシーンに遷移する
		# current_directorを次のシーンの担当ディレクターオブジェクトに差し替える。
		# メインループ側でcurrent_directorを毎フレーム参照しているので、これによって次のフレーム描画から
		# 別のディレクターが処理を担当するようになる。
		def transition_to_next_director
			self.current_director = self.next_director
		end
	end
end
