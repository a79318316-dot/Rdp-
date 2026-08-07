#!/usr/bin/env bash
# setup.sh — Runner açılınca çalışır. Profil seçenekli.
# Kullanım: ./setup.sh [data|ml|web|minimal]
# Ubuntu-latest: 4 CPU, 16 GB RAM (public), 14 GB SSD

set -e

PROFILE="${1:-data}"

echo "=== SETUP PROFİLİ: $PROFILE ==="
echo "Makine: $(nproc) CPU, $(free -h | awk '/^Mem:/ {print $2}') RAM"

echo "=== Temel araçlar ==="
sudo apt-get update -y -qq
sudo apt-get install -y -qq \
  htop tmux vim tree jq unzip wget curl build-essential \
  ca-certificates software-properties-common 2>&1 | tail -3

echo "=== Python pip güncelle ==="
pip install --upgrade pip --quiet 2>&1 | tail -1

# ---- PROFİLLİ KURULUM ----
case "$PROFILE" in
  data)
    echo "=== [data] Veri analizi seti ==="
    pip install --quiet pandas numpy matplotlib seaborn scikit-learn \
      requests jupyterlab openpyxl xlsxwriter 2>&1 | tail -2
    ;;
  ml)
    echo "=== [ml] Makine öğrenmesi seti (CPU torch) ==="
    pip install --quiet pandas numpy matplotlib scikit-learn \
      torch --index-url https://download.pytorch.org/whl/cpu 2>&1 | tail -2
    pip install --quiet transformers tokenizers jupyterlab 2>&1 | tail -2
    ;;
  web)
    echo "=== [web] Web geliştirme seti ==="
    sudo apt-get install -y -qq nginx 2>&1 | tail -1
    npm install -g pm2 2>&1 | tail -1
    pip install --quiet fastapi uvicorn requests 2>&1 | tail -1
    ;;
  minimal)
    echo "=== [minimal] Sadece temel araçlar ==="
    pip install --quiet requests 2>&1 | tail -1
    ;;
  *)
    echo "Bilinmeyen profil: $PROFILE — data varsayılıyor"
    pip install --quiet pandas numpy matplotlib requests 2>&1 | tail -1
    ;;
esac

echo "=== Çalışma dizini ==="
mkdir -p ~/workspace
cat > ~/workspace/WELCOME.txt <<'EOF'
Hoş geldin SuperNinja!
Bu makine senin için hazır. ~/workspace içinde çalış.
Önemli dosyaları repo'ya commit'le — makine job bitince silinir.
EOF

echo ""
echo "=== KURULU PAKETLER (özet) ==="
pip list 2>/dev/null | tail -n +3 | wc -l | xargs echo "Python paket sayısı:"
which python3 node git tmux 2>&1
echo ""
echo "=== SETUP TAMAM ==="
