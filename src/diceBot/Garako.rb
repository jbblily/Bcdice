# -*- coding: utf-8 -*-

class Garako < DiceBot
  setPrefixes([
    'PNM', 'PNF', 'ENM', 'ENF', 'NNM', 'NNF',
    'RNM', 'RNF', 'BN1', 'BN2', 'TN1', 'TN2',
    'IDI', 'MTV', 'HIT', '(C|E|F|A|L)DC\d+', 'GR.*',
    'GCC', 'WCC', 'EVC', 'BSD'
  ])

  def initialize
    super
  end

  def gameName
    'ガラコと破界の塔'
  end

  def gameType
    "Garako"
  end

  def getHelpMessage
    return <<MESSAGETEXT
・判定
GR+n>=X：「+n」で判定値を指定、「X」で目標値を指定。
・部位決定チャート：HIT
・ダメージチャート：xDC（CDC/EDC/FDC/ADC/LDC)
　xは C：コックピット、E：エンジン、F：フレーム、A：アーム、L：レッグ
各種表
・個性表：IDI／動機決定表：MTV
・名前表
ピグマー族　　男：PNM　女：PNF　　エレメント族　男：ENM　女：ENF
ノーマッド族　男：NNM　女：NNF　　ラット族　　　男：RNM　女：RNF
ブレイン族　　１：BN1　２：BN2　　テンタクル族　１：TN1　２：TN2
・ガラコ改造チャート表：GCC
・武器改造チャート表：WCC
・イベントチャート表：EVC
・戦闘開始距離：BSD
MESSAGETEXT
  end

  def rollDiceCommand(command)
    output =
      case command.upcase

      when /^GR((\+|\-)\d+)?>=(\d+)$/i
        modifyString = $1
        targetString = $3
        checkRoll(modifyString, targetString)

      when /(\w)DC(\d+)/i
        part = $1.upcase
        damage = $2.to_i
        get_damage_chart(part, damage)

      when 'PNM'
        get_nametable_pm
      when 'PNF'
        get_nametable_pf
      when 'ENM'
        get_nametable_em
      when 'ENF'
        get_nametable_ef
      when 'NNM'
        get_nametable_nm
      when 'NNF'
        get_nametable_nf
      when 'RNM'
        get_nametable_rm
      when 'RNF'
        get_nametable_rf
      when 'BN1'
        get_nametable_b1
      when 'BN2'
        get_nametable_b2
      when 'TN1'
        get_nametable_t1
      when 'TN2'
        get_nametable_t2
      when 'IDI'
        get_idiosyncrasy_table
      when 'MTV'
        get_motivation_table
      when 'HIT'
        get_damage_region_chart
      when 'GCC'
        get_garako_custom_chart
      when 'WCC'
        get_weapon_custom_chart
      when 'EVC'
        get_event_chart
      when 'BSD'
        get_battle_start_distance
      end

    return output
  end

  def checkRoll(modifyString, targetString)
    modify = modifyString.to_i
    target = targetString.to_i

    dice, = roll(1, 10)
    total = (dice + modify)

    text = getResultText(dice, total, target)

    result = ""
    result += "(1D10#{modifyString}>#{total})"
    result += " ＞ #{total}[#{dice}#{modifyString}] ＞ #{total} ＞ #{text}"

    return result
  end

  def getResultText(dice, total, target)
    return "ファンブル" if dice == 1
    return "クリティカル" if dice == 10

    if total < target
      return "失敗"
    end

    return "成功"
  end

  def get_nametable_pm
    name = '名前表：ピグマー族（男）'
    table = [
              [1, 'バビロン'],
              [2, 'グリニッジ'],
              [3, 'デトロイト'],
              [4, 'ヨコスカ'],
              [5, 'ボルドー'],
              [6, 'テキサス'],
              [7, 'シチリア'],
              [8, 'チェルノブイリ'],
              [9, 'グンマ'],
              [10, 'サマルトリア']
            ]
    return get_garako_1d10_table_result(name, table)
  end

  def get_nametable_pf
    name = '名前表：ピグマー族（女）'
    table = [
              [1, 'ルアンダ'],
              [2, 'ローマ'],
              [3, 'フロリダ'],
              [4, 'ホノルル'],
              [5, 'ツガル'],
              [6, 'ゲルニカ'],
              [7, 'シャンハイ'],
              [8, 'モナコ'],
              [9, 'チグリス'],
              [10, 'オーサカ']
            ]
    return get_garako_1d10_table_result(name, table)
  end

  def get_nametable_em
    name = '名前表：エレメント族（男）'
    table = [
              [1, 'アポロン'],
              [2, 'ミキストリ'],
              [3, 'アザゼル'],
              [4, 'フマクト'],
              [5, 'マサカド'],
              [6, 'ククルカン'],
              [7, 'ルシフェル'],
              [8, 'ザギグ'],
              [9, 'フェムト'],
              [10, 'マイトレーヤ']
            ]
    return get_garako_1d10_table_result(name, table)
  end

  def get_nametable_ef
    name = '名前表：エレメント族（女）'
    table = [
              [1, 'クシナダ'],
              [2, 'アルテミス'],
              [3, 'ゼノビア'],
              [4, 'フレイヤ'],
              [5, 'イシュタム'],
              [6, 'ベルゼバブ'],
              [7, 'マイシェラ'],
              [8, 'バステト'],
              [9, 'スクルド'],
              [10, 'アテナ']
            ]
    return get_garako_1d10_table_result(name, table)
  end

  def get_nametable_nm
    name = '名前表：ノーマッド族（男）'
    table = [
              [1, 'ドラム'],
              [2, 'カホン'],
              [3, 'ハレルヤ'],
              [4, 'トリノウタ'],
              [5, 'スリラー'],
              [6, 'シンバル'],
              [7, 'リュート'],
              [8, 'ウクレレ'],
              [9, 'タンバリン'],
              [10, 'ユメコウネン']
            ]
    return get_garako_1d10_table_result(name, table)
  end

  def get_nametable_nf
    name = '名前表：ノーマッド族（女）'
    table = [
              [1, 'ピアノ'],
              [2, 'テルミン'],
              [3, 'ソバカス'],
              [4, 'イマジン'],
              [5, 'ツナミ'],
              [6, 'ピッコロ'],
              [7, 'ハープ'],
              [8, 'シャミセン'],
              [9, 'ミザルー'],
              [10, 'ドナドナ']
            ]
    return get_garako_1d10_table_result(name, table)
  end

  def get_nametable_rm
    name = '名前表：ラット族（男）'
    table = [
              [1, 'ポチ'],
              [2, 'シシマル'],
              [3, 'ポンタ'],
              [4, 'コテツ'],
              [5, 'アルフォンス'],
              [6, 'パトラッシュ'],
              [7, 'ミッキー'],
              [8, 'ジジ'],
              [9, 'サカモト'],
              [10, 'オンソクマル']
            ]
    return get_garako_1d10_table_result(name, table)
  end

  def get_nametable_rf
    name = '名前表：ラット族（女）'
    table = [
              [1, 'タマ'],
              [2, 'ココ'],
              [3, 'ラブ'],
              [4, 'ピーコ'],
              [5, 'モカ'],
              [6, 'オリガミ'],
              [7, 'ヒメ'],
              [8, 'ミィ'],
              [9, 'ルナ'],
              [10, 'ク・メル']
            ]
    return get_garako_1d10_table_result(name, table)
  end

  def get_nametable_b1
    name = '名前表：ブレイン族（その１）'
    table = [
              [1, 'マリファナ'],
              [2, 'バファリン'],
              [3, 'タミフル'],
              [4, 'セーロガン'],
              [5, 'モルヒネ'],
              [6, 'ハルシオン'],
              [7, 'トリカブト'],
              [8, 'バイアグラ'],
              [9, 'エリクサー'],
              [10, 'クラレ']
            ]
    return get_garako_1d10_table_result(name, table)
  end

  def get_nametable_b2
    name = '名前表：ブレイン族（その２）'
    table = [
              [1, 'ニトロ'],
              [2, 'ダイオキシン'],
              [3, 'タウリン'],
              [4, 'コイーバ'],
              [5, 'マールボロ'],
              [6, 'キャメル'],
              [7, 'ドクダミ'],
              [8, 'アブサン'],
              [9, 'ドブロク'],
              [10, 'マティーニ']
            ]
    return get_garako_1d10_table_result(name, table)
  end

  def get_nametable_t1
    name = '名前表：テンタクル族（その１）'
    table = [
              [1, 'アップル'],
              [2, 'プリン'],
              [3, 'ビフテキ'],
              [4, 'ガンモ'],
              [5, 'レバニラ'],
              [6, 'カボチャ'],
              [7, 'コロッケ'],
              [8, 'マトン'],
              [9, 'ギョーザ'],
              [10, 'タバスコ']
            ]
    return get_garako_1d10_table_result(name, table)
  end

  def get_nametable_t2
    name = '名前表：テンタクル族（その２）'
    table = [
              [1, 'キノコ'],
              [2, 'セロリ'],
              [3, 'ラザニア'],
              [4, 'ユドーフ'],
              [5, 'ニンジン'],
              [6, 'カイワレ'],
              [7, 'ボルシチ'],
              [8, 'ハクサイ'],
              [9, 'キャラメル'],
              [10, 'ワタアメ']
            ]
    return get_garako_1d10_table_result(name, table)
  end

  def get_idiosyncrasy_table
    name = '個性表'
    table = [
              [1, '〈近接武器熟練〉 近接攻撃の火力+1。'],
              [2, '〈近接武器熟練〉 近接攻撃の火力+1。'],
              [3, '〈近接武器熟練〉 近接攻撃の火力+1。'],
              [4, '〈近接武器熟練〉 近接攻撃の火力+1。'],
              [5, '〈近接武器熟練〉 近接攻撃の火力+1。'],
              [6, '〈遠隔武器熟練〉 遠隔攻撃の火力+1。'],
              [7, '〈遠隔武器熟練〉 遠隔攻撃の火力+1。'],
              [8, '〈遠隔武器熟練〉 遠隔攻撃の火力+1。'],
              [9, '〈遠隔武器熟練〉 遠隔攻撃の火力+1。'],
              [10, '〈遠隔武器熟練〉 遠隔攻撃の火力+1。'],
              [11, '〈天才〉 【技術】+1。'],
              [12, '〈天才〉 【技術】+1。'],
              [13, '〈天才〉 【技術】+1。'],
              [14, '〈天才〉 【技術】+1。'],
              [15, '〈天才〉 【技術】+1。'],
              [16, '〈頑強〉 【身体】+1。'],
              [17, '〈頑強〉 【身体】+1。'],
              [18, '〈頑強〉 【身体】+1。'],
              [19, '〈頑強〉 【身体】+1。'],
              [20, '〈頑強〉 【身体】+1。'],
              [21, '〈早業〉 【速度】+1。'],
              [22, '〈早業〉 【速度】+1。'],
              [23, '〈早業〉 【速度】+1。'],
              [24, '〈早業〉 【速度】+1。'],
              [25, '〈早業〉 【速度】+1。'],
              [26, '〈スイフトフット〉 【移動力】+1。'],
              [27, '〈スイフトフット〉 【移動力】+1。'],
              [28, '〈スイフトフット〉 【移動力】+1。'],
              [29, '〈スイフトフット〉 【移動力】+1。'],
              [30, '〈スイフトフット〉 【移動力】+1。'],
              [31, '〈超反応〉 行動判定値+2。'],
              [32, '〈超反応〉 行動判定値+2。'],
              [33, '〈超反応〉 行動判定値+2。'],
              [34, '〈超反応〉 行動判定値+2。'],
              [35, '〈超反応〉 行動判定値+2。'],
              [36, '〈警戒心〉 罠を発見するための判定に+2。'],
              [37, '〈警戒心〉 罠を発見するための判定に+2。'],
              [38, '〈警戒心〉 罠を発見するための判定に+2。'],
              [39, '〈警戒心〉 罠を発見するための判定に+2。'],
              [40, '〈警戒心〉 罠を発見するための判定に+2。'],
              [41, '〈解除屋〉 罠を解除するための判定に+2。'],
              [42, '〈解除屋〉 罠を解除するための判定に+2。'],
              [43, '〈解除屋〉 罠を解除するための判定に+2。'],
              [44, '〈解除屋〉 罠を解除するための判定に+2。'],
              [45, '〈解除屋〉 罠を解除するための判定に+2。'],
              [46, '〈タフガイ〉 最大HP+5。'],
              [47, '〈タフガイ〉 最大HP+5。'],
              [48, '〈タフガイ〉 最大HP+5。'],
              [49, '〈タフガイ〉 最大HP+5。'],
              [50, '〈タフガイ〉 最大HP+5。'],
              [51, '〈踏み込み〉 キミが使用する近接武器のデータを「射程：2」に変更する。'],
              [52, '〈不動〉 キミは強制移動の効果を受けない。'],
              [53, '〈ペイローダー〉 ガラコの【限界重量】+2000。'],
              [54, '〈魅力〉 キミがHPを回復するアイテム、もしくは超能力の目標になった時、キミのHPを追加で1点回復する。'],
              [55, '〈ダブルタップ〉 キミのターン開始時に使用。このターンの間、キミは追加で1回の遠隔攻撃を行うことができる。'],
              [56, '〈薙ぎ払い〉 キミのターン開始時に使用。このターンの間、キミが行う近接攻撃の目標を「周囲1マス以内にいるすべての敵」に変更する。'],
              [57, '〈武器落とし〉 キミは部位ひとつを指定する。目標は指定された部位に（スロットを消費して）装着している武器すべてを地面に落とす。'],
              [58, '〈切り払い〉 キミが行う回避判定の直前に使用。その判定を、【機動性】ではなく【操作性】で判定してよい。ただし、キミは近接武器を装着していなければならない。'],
              [59, '〈体崩しの達人〉 キミが目標のレッグに攻撃を命中させる度、その目標は【機動性】10の判定を行う。失敗した場合、目標は［伏せ］状態になる。'],
              [60, '〈超分解術〉 アイテムひとつを目標にする。目標のアイテムの重量を1/4にする。ただし、そのアイテムは使用できなくなる。再度〈超分解術〉の判定に成功することで、元に戻せる（重量が元に戻り、アイテムが使用可能になる）。'],
              [61, '〈即時換装〉 キミは、ガラコのパーツ換装を（ベースアクションではなく）ムーブアクションで行ってもよい。'],
              [62, '〈ノックバック〉 キミが目標に5点以上の最終ダメージを与えた直後に使用。目標を1マス、任意の方向に強制移動させる。近接武器で攻撃した場合のみ使用できる。'],
              [63, '〈照準〉 このターンの間、次に行う攻撃の命中判定+1。'],
              [64, '〈燃料節約術〉 戦闘時以外、キミは燃料を消費しなくてよい。'],
              [65, '〈追撃〉 キミの敵が、隣接するマスから離れるような移動を宣言した直後に使用。キミはその敵に対して近接攻撃を行う。近接攻撃の後、敵は移動を行うこと。'],
              [66, '〈連撃〉 キミが敵の部位を［修復不能］にした直後に使用。キミは再度、その敵に対して攻撃を行う。'],
              [67, '〈殺し屋〉 キミがコックピットに攻撃を命中させる度、そのガラコの操縦者は2点のHPを失う。'],
              [68, '〈極大射程〉 キミが扱う遠隔武器の射程を2倍にする。'],
              [69, '〈援護射撃〉 目標が回避判定を行った直後に使用。目標の回避判定の達成値-1。その後、キミは準備済みの遠隔武器ひとつの使用回数を1減らすこと。'],
              [70, '〈鉄壁〉 キミがダメージを受けた直後に使用。そのダメージを無効化する。'],
              [71, '〈心臓狙い〉 キミが部位狙いを行い、コックピット、もしくはエンジンに対して攻撃を行う際、命中判定+1。'],
              [72, '〈四肢狙い〉 キミが部位狙いを行い、アーム、もしくはレッグに対して攻撃を行う際、命中判定+1。'],
              [73, '〈窮地逆転〉 キミの判定の出目が1だった時、その出目を10に変更する。'],
              [74, '〈防御重視〉 ラウンド開始時に使用。【操作性】-1。【機動性】+2。ラウンド終了時まで。'],
              [75, '〈チアガール〉 目標は即座に追加のターンを得る。'],
              [76, '〈毒半減〉 キミが［毒］状態になった時、毎回失うHPを1点減らす。ノーマッド族はこの個性を取得できない。'],
              [77, '〈毒無効〉 キミは［毒］状態にならない。この個性はノーマッド族だけが取得できる。'],
              [78, '〈生存術〉 キミは各シーン終了時、HPを減らさなくてよい。'],
              [79, '〈平衡感覚〉 キミは［不安定］状態のペナルティを受けない。'],
              [80, '〈不屈〉 キミのターン開始時に使用。このターンの間、キミはガラコの損傷による［弱体］の効果を受けない。'],
              [81, '〈プレデターセンス〉 近接攻撃の命中判定+2。この個性はラット族だけが取得できる。'],
              [82, '〈鷹の目〉 遠隔攻撃の命中判定+2。この個性はラット族だけが取得できる。'],
              [83, '〈超リペア術〉 部位をひとつ選択する。目標の部位の被ダメージすべてを一時的に回復する（修復不能を除く）。回復したダメージは、シーン終了時に元に戻る（再度壊れる）。この個性はブレイン族のみが取得できる。'],
              [84, '〈浮遊術〉 キミは［飛行］状態になる。シーン終了時まで。この個性はテンタクル人のみが取得できる。'],
              [85, '〈瞬間移動術〉 キミは任意のマスに瞬間移動する。この個性はテンタクル人のみが取得できる。'],
              [86, '〈ハイボルテージ〉 4ラウンドめ以降、キミが持つすべての武器の火力を+2する。'],
              [87, '〈スライドディフェンス〉 キミが部位決定チャートを振った直後に使用。チャートの結果を+1する。'],
              [88, '〈カーブアタック〉 目標が部位決定チャートを振った直後に使用。チャートの結果を-1する。'],
              [89, '〈サイコショット〉 目標に［火力0］の攻撃を行う（自動命中）。（超能力）'],
              [90, '〈ファイア〉 目標に［火力5］の攻撃を行う。（超能力）'],
              [91, '〈アイス〉 目標に［火力3］の攻撃を行う。（超能力）'],
              [92, '〈サンダー〉 目標に［火力2］の攻撃を行う。（超能力）'],
              [93, '〈テレパシー〉 キミは念話によって会話することができる。（超能力）'],
              [94, '〈ミラー〉 目標が超能力の使用を宣言した直後に使用。超能力の目標を使用者自身に変更する。（超能力）'],
              [95, '〈バインド〉 目標のターン開始時に使用。目標の移動力-3。ターン終了時まで。（超能力）'],
              [96, '〈アーマー〉 目標のすべての部位装甲+2。シーン終了時まで。（超能力）'],
              [97, '〈バリア〉 目標がダメージを受けた直後に使用。ダメージを3点軽減する。（超能力）'],
              [98, '〈ヒール〉 目標のHPを［1d10-4］点回復する。出目が低いとHPを失う可能性があることに注意。（超能力）'],
              [99, '〈カース〉 目標が判定を行った直後に使用。その判定の達成値を-3する。'],
              [100, '〈リザレクション〉 死んだ目標を生き返らせる。生き返った目標のHPは10になる。このシーンの間に死亡したキャラクターのみ目標にできる。（超能力）'],
            ]

    dice, = roll(1, 100)
    result = get_table_by_number(dice, table)

    return get_garako_table_result(name, dice, result)
  end

  def get_motivation_table
    name = '動機決定表'
    table = [
              [1, '金。お宝の臭いがした。'],
              [2, '正義。破界の塔は災いのもと。絶たねばならない。'],
              [3, '友情。この破界の塔のせいで友人が困っている。助けなくちゃ。'],
              [4, '探究心。破界の塔のことをもっと知りたい。'],
              [5, '戦闘狂。もっと戦いたい。'],
              [6, '暇つぶし。退屈な日常を忘れたい。'],
              [7, '自殺願望。なんかもう死にたい。'],
              [8, '冒険家。ワクワクしたい。'],
              [9, '山男。シティが肌に合わない。'],
              [10, '特に動機らしい動機はない。']
            ]
    return get_garako_1d10_table_result(name, table)
  end

  def get_damage_region_chart
    name = '部位決定チャート'
    table = [
              [1, 'コックピット'],
              [2, 'エンジン'],
              [3, 'フレーム'],
              [4, 'フレーム'],
              [5, 'フレーム'],
              [6, 'フレーム'],
              [7, 'ライトアーム'],
              [8, 'レフトアーム'],
              [9, 'ライトレッグ'],
              [10, 'レフトレッグ']
            ]
    return get_garako_1d10_table_result(name, table)
  end

  # 部位ダメージチャート
  def get_damage_chart(part, damage)
    name, table =
      case part
      when 'C'
        get_damagechart_cockpit
      when 'E'
        get_damagechart_engine
      when 'F'
        get_damagechart_frame
      when 'A'
        get_damagechart_arm
      when 'L'
        get_damagechart_leg
      end

    return nil if table.nil?

    tableMaxValue = table.last[0]
    damage = [damage, tableMaxValue].min

    result = get_table_by_number(damage , table)

    return get_garako_table_result(name, damage, result)
  end

  def get_damagechart_cockpit
    name = "部位ダメージチャート：コックピット"
    table =
      [
       [1, '小破（アーマー損傷）：以後、この部位の【部位装甲】-1。'],
       [2, '小破（視界不良）：モニターやハッチの歪み等により、視界を大きく遮られる。以後、【視認性】-1、【部位装甲】-1。'],
       [3, '小破（強震）：大きく揺さぶられる。キミは【身体】10の判定を行う。失敗した場合、次のターンを失う。【部位装甲】-1。'],
       [4, '小破（収納直撃）：アイテム収納スペースに直撃！　所持品一つにつき1d10を振れ。出目が5以下だった所持品は破壊される。【部位装甲】-1。'],
       [5, '中破（計器損傷）：コンソールの一部が停止する。［弱体1］を受ける。'],
       [6, '中破（制御不能）：コントロールが効かなくなる。キミは次のターンを失う。［弱体1］を受ける。'],
       [7, '中破（貫通！）：パイロットに被害が！　キミはHPダメージ（1d10-【身体】）に加え、［弱体1］を受ける。'],
       [8, '大破（故障）：コックピットが完全にいかれる。キミは次のラウンド終了時まで、あらゆる判定に自動的にファンブルする。［弱体1］を受ける。'],
       [9, '大破（貫通！）：パイロットに被害が！　キミはHPダメージ（1d10+3-【身体】）に加え、［弱体1］を受ける。'],
       [10, '修復不能（破壊）：コックピットが［修復不能］となる。キミは2d10-【身体】点のHPダメージを受ける。ガラコはすべての機能を停止する。コックピットのハッチが自動的に開く。'],
      ]

    return name, table
  end

  def get_damagechart_engine
    name = "部位ダメージチャート：エンジン"
    table =
      [
       [1, '小破（アーマー損傷）：以後、この部位の【部位装甲】-1。'],
       [2, '小破（アーマー損傷）：以後、この部位の【部位装甲】-1。'],
       [3, '小破（燃料漏れ）：タンクから燃料が漏れる。燃料-1。この部位の【部位装甲】-1。'],
       [4, '小破（燃料漏れ）：タンクから燃料が漏れる。燃料-2。この部位の【部位装甲】-1。'],
       [5, '中破（エンジン不調）：時々エンジンが動かなくなる。［弱体1］を受ける。'],
       [6, '中破（燃料漏れ）：タンクから燃料が漏れる。燃料-2。［弱体1］を受ける。'],
       [7, '中破（ヒート）：オーバーヒートする。次のターンの終了時まで、移動と攻撃を行えない。［弱体1］を受ける。'],
       [8, '大破（エンジン不調）：キミは次のターンを失う。［弱体1］を受ける。'],
       [9, '大破（故障）：以後、この部位の【部位装甲】が0になる。［弱体1］を受ける。'],
       [10, '修復不能（エンジン停止）：エンジンが停止する。ガラコはすべての機能を停止する。コックピットのハッチが自動的に開く。【操作性】10の判定を行うこと。失敗するとエンジンが爆発する。その場合、すべての部位が［修復不能］となり、キミは2d10-【身体】点のダメージを受ける。'],
      ]

    return name, table
  end

  def get_damagechart_frame
    name = "部位ダメージチャート：フレーム"
    table =
      [
       [1, '小破（不安定）：体勢を崩す。次のターン、キミは攻撃を行えない。この部位の【部位装甲】-1。'],
       [2, '小破（スクラッチ！）：フレームに醜い傷が残る。この部位の【部位装甲】-1。'],
       [3, '小破（アーマー損傷）：フレームが歪む。この部位の【部位装甲】-1。'],
       [4, '小破（アーマー損傷）：フレームがきしみ始め、ガラコの動きを阻害し始める。【移動力】-1。さらに、この部位の【部位装甲】-1。'],
       [5, '中破（放熱板損傷）：熱を機体外に逃すことができなくなる。［弱体1］を受ける。'],
       [6, '中破（スタビライザー損傷）：機体のバランス調整装置が故障する。【身体】10の判定を行うこと。失敗した場合、キミは次のターンを失う。［弱体1］を受ける。'],
       [7, '中破（貫通！）：パイロットに被害が！　キミはHPダメージ（1d10-【身体】）を受ける。［弱体1］を受ける。'],
       [8, '大破（停止）：フレームが動かない。キミは次のターンを失う。［弱体1］を受ける。'],
       [9, '大破（アーマー損傷）：フレームに甚大なダメージを受ける。以後、この部位の【部位装甲】に-3。［弱体1］を受ける。'],
       [10, '修復不能（フレーム崩壊）：フレームが［修復不能］となる。フレームの大部分が剥がれ落ち、ガラコの内部が晒される。以後、キミに対して部位狙いが行われる場合、その命中判定に対する修正（p21）は発生しなくなる。［弱体2］を受ける。'],
      ]

    return name, table
  end

  def get_damagechart_arm
    name = "部位ダメージチャート：アーム"
    table =
      [
       [1, '小破（アーマー損傷）：アームの装甲にヒビが入る。【部位装甲】-1。'],
       [2, '小破（武器落とし！）：【身体】8の判定を行う。失敗した場合、ダメージを受けた側のアームに（スロットを消費して）装着していた武器を落とす。【部位装甲】-1。'],
       [3, '小破（マニュピレータ損傷）：指が何本かちぎれ飛んだ。【操作性】-1、【部位装甲】-1。'],
       [4, '小破（機能停止）：次のターンの終了時まで、このアームを使った攻撃はできない。以後、この部位の【部位装甲】-1。'],
       [5, '中破（痙攣）：アームの動きがぶれ始める。［弱体1］を受ける。'],
       [6, '中破（武器落とし！）：ダメージを受けた側のアームに（スロットを消費して）装着していた武器を落とす。［弱体1］を受ける。'],
       [7, '中破（スピン）：機体が大きく回転する。【身体】10の判定を行うこと。失敗した場合、［伏せ］状態となった上、次のターンを失う。［弱体1］を受ける。'],
       [8, '大破（アーマー損傷）：以後、この部位の【部位装甲】を-3。［弱体1］を受ける。'],
       [9, '大破（武器落とし！）：ダメージを受けた側のアームに（スロットを消費して）装着していた武器を落とす。以後、この部位の【部位装甲】が0になる。［弱体1］を受ける。'],
       [10, '修復不能（破壊）：ダメージを受けた側のアームが［修復不能］となる。［弱体2］を受ける。'],
      ]

    return name, table
  end

  def get_damagechart_leg
    name = "部位ダメージチャート：レッグ"
    table =
      [
       [1, '小破（アーマー損傷）：以後、この部位の【部位装甲】-1。'],
       [2, '小破（よろめき）：以後、この部位の【部位装甲】-1。次のターン終了時まで、キミは移動できない。'],
       [3, '小破（スネア）：足元をすくわれる。【部位装甲】-1。さらに【身体】8の判定を行うこと。失敗した場合、キミは［伏せ］状態になる。'],
       [4, '小破（跛足）：以後、【移動力】-1、【部位装甲】-1。'],
       [5, '中破（シャフト損傷）：脚部の軸に歪みが生じる。［弱体1］を受ける。'],
       [6, '中破（アクチュエータ損傷）：脚部のアクチュエータに大きな損傷を受ける。【移動力】-1。［弱体1］を受ける。'],
       [7, '中破（スピン）：機体が大きく回転する。【身体】10の判定を行うこと。失敗した場合、［伏せ］状態となった上、次のターンを失う。［弱体1］を受ける。'],
       [8, '大破（アーマー損傷）：以後、この部位の【部位装甲】を-3。［弱体1］を受ける。'],
       [9, '大破（跛足）：以後、【移動力】-2。この部位の【部位装甲】が0になる。［弱体1］を受ける。'],
       [10, '修復不能（破壊）：ダメージを受けた側のレッグが［修復不能］となる。【移動力】-2。［弱体2］を受ける。'],
      ]

    return name, table
  end

  def get_garako_custom_chart()
    name = "ガラコ改造チャート表"
    table = [
             [1, "【命中+】価格+200。【操作性】+1。［不安定］1。"],
             [2, "【回避+】価格+200。【機動性】+1。［不安定］1。"],
             [3, "【視界+】価格+200。【視認性】+2。［不安定］1。"],
             [4, "【移動+】価格+100。【移動力】+1。"],
             [5, "【火力+】価格+200。その部位に装着した武器の火力を常に+2する。"],
             [6, "【部位装甲+】価格+100。【部位装甲】+2。"],
             [7, "【限界重量+】価格+100。【限界重量】+1000。"],
             [8, "【安定性+】価格+50。［不安定］-1。"],
             [9, "【スロット+】価格+500。【スロット】+1。"],
             [10, "【弱体無効】価格+500。このパーツへの部位ダメージによる[弱体]の効果を無視する。"],
            ]
    return get_garako_1d10_table_result(name, table)
  end

  def get_weapon_custom_chart()
    name = "武器改造チャート表"
    table = [
             [1, "【命中+】価格+200。【操作性】+1。"],
             [2, "【火力+】価格+200。【火力】+2。"],
             [3, "【射程】価格+200。【射程】+3。「射程：近接」の場合、「射程:3 or 近接」となる(攻撃する度にどちらかを選ぶ)。"],
             [4, "【範囲+】価格+200。1シーンにつき1回、この武器の目標を「範囲2」に変更してもよい(フリーアクション)。もともと範囲攻撃できる武器の場合は、「範囲n+1」にできる(1シーン1回、フリーアクション)。"],
             [5, "【部位変更】価格+200。装着できる部位がランダムに追加される。部位決定チャート(『GHT』p21)を使用して決めること。"],
             [6, "【部位装甲+】価格+100。装着した部位の【部位装甲】+2。"],
             [7, "【精度+】価格+100。この武器を使って狙い撃ちをする場合、命中判定に+1。"],
             [8, "【装飾+】価格+500。特に効果はないが、売却した時の金額が上昇する。"],
             [9, "【幸運+】価格+500。この武器による命中判定の出目が1だった場合、判定を振り直しても良い(1シーン1回まで)。"],
             [10, "【回数無限】価格+500。武器の使用回数制限がなくなる。"],
            ]
    return get_garako_1d10_table_result(name, table)
  end

  def get_event_chart
    name = "イベントチャート表"
    table = [
             [1, "【クリーチャー】スタートル(『GTD』p30)が1d10+3体現れる。戦闘開始。"],
             [2, "【ビット】コーンノーズ(『GTD』p23)が1d10+3体現れる。戦闘開始。"],
             [3, "【ノーマッド】ノーマッド族のランドクローラーと遭遇する。このシーンはノーマッドからアイテムを購入しても良い。ノーマッド族は天蓋都市で購入できるすべてのアイテムを販売している(ただし金額は20%増し)。"],
             [4, "【ピグマー族】君達の目的地方面から、ボロボロになったピグマー族のNPCが歩いてくる。NPCに何があったのかはGMが決めよ。ピグマー族を天蓋都市まで送った場合、謝礼として200クレジットを受け取ることが出来る。NPCは重量50のアイテムとして扱う。"],
             [5, "【ビット】ダスクウォッチ(『GTD』p23)が1d10+3体現れる。戦闘開始。"],
             [6, "【異常気象】嵐、竜巻、豪雨など、異常な気象によって行動を阻害される。PCのうち代表者1名が【視認】10の判定を行うこと。失敗した場合、次のシーンはスポットを移動できない。現在のスポットに留まることになる。"],
             [7, "【クリーチャー】ナグ(『GTD』p31)が1d10+4体現れる。戦闘開始。"],
             [8, "【ビット】ランオーバー(『GTD』p25)が3体現れる。戦闘開始。"],
             [9, "【猛毒の霧】付近に毒の霧が立ち込める。全てのキャラクターは毒によって1d10のHPダメージを受ける。"],
             [10, "【最悪の敵】ズルワーン(『GTD』p29)が1体現れる。戦闘開始。"],
            ]
    return get_garako_1d10_table_result(name, table)
  end

  def get_battle_start_distance
    name = "戦闘開始距離"
    table = [
             [1, "3マス"],
             [2, "3マス"],
             [3, "6マス"],
             [4, "6マス"],
             [5, "9マス"],
             [6, "9マス"],
             [7, "12マス"],
             [8, "12マス"],
             [9, "15マス"],
             [10, "15マス"],
            ]
    return get_garako_1d10_table_result(name, table)
  end

  def get_garako_1d10_table_result(name, table)
    dice, = roll(1, 10)
    output = get_table_by_number(dice, table)
    return get_garako_table_result(name, dice, output)
  end

  def get_garako_table_result(name, dice, output)
    return "#{name}(#{dice}) ＞ #{output}"
  end
end
