require 'mittsu'

Dir.glob("lib/*.rb") {|path| require_relative path }
Dir.glob("directors/*.rb") {|path| require_relative path }

SCREEN_WIDTH = 1024
SCREEN_HEIGHT = 768
ASPECT_RATIO = SCREEN_WIDTH / SCREEN_HEIGHT.to_f

# 全体で共通のレンダラーを生成
renderer = Mittsu::OpenGLRenderer.new width: SCREEN_WIDTH, height: SCREEN_HEIGHT, title: 'RubyCamp 2022 Example'

# 初期シーンのディレクターオブジェクトを生成
director = Directors::TitleDirector.new(screen_width: SCREEN_WIDTH, screen_height: SCREEN_HEIGHT, renderer: renderer)

# キー押下時のイベントハンドラを登録
renderer.window.on_key_pressed do |glfw_key|
  director.on_key_pressed(glfw_key: glfw_key)
end

# メインループ
renderer.window.run do
  # 現在のディレクターオブジェクトに、処理対象となるディレクターオブジェクトを返させる
  # ※ これによって、シーン切替を実現している。メカニズムの詳細はdirectors/base.rb参照
  director = director.current_director

  # 処理対象のディレクターオブジェクトが返ってこない（nilが返ってくる）場合はメインループを抜ける
  break unless director

  # １フレーム分、最新のディレクターオブジェクトを進行させる
  director.play

  # 現在のディレクターオブジェクトが保持するシーンを、同じく現在のディレクターオブジェクトが持つカメラでレンダリング
  renderer.render(
    director.scene,
    director.camera)
end
