import os
import json
import subprocess
import re


# Sagemakerのカスタムコンテナでの入出力ファイル
# 入力:ハイパーパラメターファイル
HYPER_PARAMETER_JSON_PATH = "/opt/ml/input/config/hyperparameters.json"
# 入力:学習データディレクトリ
TRAIN_DIR = "/opt/ml/input/data/train"
# 出力:モデルデータディレクトリ
MODEL_DIR = "/opt/ml/model"

if __name__ == '__main__':
    with open(HYPER_PARAMETER_JSON_PATH, "r") as f:
        hyper_parameters = json.load(f)

    # ハイパーパラメタを確認のため出力
    print("---hyper parameters--")
    print(print(json.dumps(hyper_parameters, indent=2)))
    print("----")

    # 学習データファイル
    data_file=os.path.join(TRAIN_DIR, hyper_parameters["data_file"])
    cfg_file=os.path.join(TRAIN_DIR, hyper_parameters["cfg_file"])
   
    # darknetの学習プロセスの起動
    subprocess.run(["./darknet", "detector", "train", data_file, cfg_file, "weights/yolov4.conv.137", "-dont_show"])

