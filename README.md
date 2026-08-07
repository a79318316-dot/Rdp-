# Rdp- → Remote Shell (Ubuntu + SSH + ngrok)

Bu repo SuperNinja'nın **GitHub Actions runner'ına ngrok ile SSH tüneli** açıp
güçlü bir Ubuntu makinede çalışmasını sağlar.

## Makine Özellikleri
| Özellik | Public repo | Private repo |
|---|---|---|
| CPU | 4 vCPU | 2 vCPU |
| RAM | **16 GB** | 8 GB |
| Disk | 14 GB SSD | 14 GB SSD |
| Ücretsiz dakika | **Sınırsız** | 2000 dk/ay |

➡️ **Repo PUBLIC olursa 16 GB RAM alırsın** (sandbox'ın 4 katı).
Private repo 8 GB RAM verir ve free dakika düşürür.

## Limitler
- Job max **6 saat** (360 dk) — `sleep` ile doldurulur
- Makine **temp** — job bitince silinir, önemli dosyaları repo'ya commit'le
- ngrok free = random adres (her seferinde değişir)

---

## 🚀 Kurulum (Sana Düşen — 3 Adım)

### Adım 1: Repo'yu PUBLIC yap (16 GB RAM için)
GitHub → repo Settings → General → en altta "Change visibility" → Public

> İstemiyorsan private kalır ama RAM 8 GB'a düşer.

### Adım 2: ngrok ücretsiz hesap + token al
1. https://dashboard.ngrok.com/signup → e-posta ile kayıt ol (ücretsiz)
2. https://dashboard.ngrok.com/get-started/your-authtoken → token'ı kopyala

### Adım 3: GitHub secrets'a token ekle
1. Repo → **Settings** → **Secrets and variables** → **Actions**
2. **New repository secret**
3. Name: `NGROK_AUTHTOKEN`
4. Value: (ngrok token'ın)
5. Add secret

✅ Bu kadar! Artık workflow'u tetikleyebilirsin.

---

## ▶️ Çalıştırma

1. Repo → **Actions** sekmesi
2. Sol menüden **"Remote Shell (Ubuntu + SSH + ngrok)"**
3. **Run workflow** → profil seç (data / ml / web / minimal) → Run
4. ~1-2 dakika bekle, workflow loglarını aç
5. **ngrok** adımının loglarında şuna benzer bir satır gör:
   ```
   SSH READY: tcp://0.tcp.eu.ngrok.io:12345
   ```
   veya ngrok dashboard: https://dashboard.ngrok.cloud/cloud-edge/endpoints
6. Bu `host port` bilgisini SuperNinja'ya ver

SuperNinja bağlanır:
```bash
ssh -p 12345 runner@0.tcp.eu.ngrok.io
```

---

## 🧰 Setup Profilleri (`setup.sh`)

Workflow'u tetiklerken profil seçersin:

| Profil | Ne kurar | RAM/Disk kullanımı |
|---|---|---|
| `data` | pandas, numpy, matplotlib, seaborn, scikit-learn, jupyterlab | orta |
| `ml` | + torch (CPU), transformers | yüksek |
| `web` | nginx, pm2, fastapi, uvicorn | düşük |
| `minimal` | sadece requests | en düşük |

Kendi paketini eklemek için `setup.sh`'yi düzenle.

---

## 📁 Dosya Yapısı
```
Rdp-/
├── .github/workflows/
│   ├── main.yml                          # Ana workflow (Ubuntu+SSH+ngrok)
│   └── main-windows-rdp-backup.yml       # Eski Windows+RDP+Tailscale (yedek)
├── setup.sh                              # Profil bazlı kurulum
├── ngrok.yml                             # ngrok SSH tüneli config
├── .gitignore
└── README.md                             # Bu dosya
```

---

## ⚠️ Önemli Notlar
- **Makine temp** — job bitince her şey silinir. Önemli çıktıları
  repo'ya commit'le veya GitHub Actions artifact olarak kaydet.
- **6 saat limit** — daha uzun istersen yeni workflow tetikle.
- **Güvenlik** — ngrok tunnel herkese açık port oluşturur ama SSH
  sadece public key ile giriş yapılabilir (varsayılan).
- **Aylık 2000 dakika** (private repo) — public repo sınırsız.
- İş bitince **workflow'u cancel et** → tunnel kapansın.

## Kaynaklar
- https://github.com/tmshkr/ngrok-ssh (hazır action)
- https://docs.github.com/en/actions/reference/runners/github-hosted-runners
- https://docs.github.com/en/actions/reference/limits
- https://ngrok.com/docs
