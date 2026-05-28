# מטלת DevOps – Jenkins + Terraform + Ansible

**סטודנט:** Matan Brosh  
**ריפוזיטורי:** https://github.com/MrBrosh/devops-final-project  
**אפליקציה מפורסת (בונוס):** [Cv-Builder](https://github.com/MrBrosh/Cv-Builder)

---

## מטרת הפרויקט

Pipeline ב‑Jenkins שמבצע אוטומציה מלאה:

1. **Terraform** – הקמת שרת Ubuntu בענן (AWS EC2) + Security Group + מפתח SSH
2. **Ansible** – התקנה והגדרה של אפליקציית **CV Builder** (React + Node.js) מאחורי Nginx
3. **ולידציה** – בדיקה שהאתר וה‑API נגישים דרך HTTP

---

## ארכיטקטורה (תרשים זרימה)

```
מרצה / סטודנט
      │
      ▼
┌─────────────┐     git pull      ┌──────────────────┐
│   Jenkins   │ ───────────────►  │ devops-final-    │
│  (Docker)   │                   │ project (GitHub)   │
└──────┬──────┘                   └──────────────────┘
       │ Build Now
       ▼
┌─────────────┐   terraform apply   ┌─────────────┐
│  Terraform  │ ──────────────────► │  AWS EC2    │
└─────────────┘                     └──────┬──────┘
       │                                   │
       │ ansible-playbook                  │ SSH :22
       ▼                                   ▼
┌─────────────┐                     ┌─────────────┐
│   Ansible   │ ──────────────────► │ CV Builder  │
│             │   clone + build     │ Nginx :80   │
└─────────────┘                     └─────────────┘
```

---

## למרצה – איך להריץ ולבדוק

> **פרטי התחברות (Jenkins + אתר)** נמסרו בהודעה בידיעון.  
> **אין לשמור סיסמאות בקובץ זה או ב‑Git.**

### 1) כניסה ל‑Jenkins

| פריט | ערך |
|------|-----|
| **URL** | http://13.63.160.119:8080 |
| **משתמש / סיסמה** | לפי מה שנמסר בידיעון |

המשתמש מוגדר עם הרשאות מוגבלות (Matrix):
- **Read** – כניסה לדשבורד
- **Job → Build, Read, Workspace** – הרצת Pipeline וצפייה בלוגים
- **View → Read**

### 2) הרצת ה‑Pipeline

1. התחברות ל‑Jenkins
2. בחר Job: **`devops-final-project`**
3. לחץ **Build Now**
4. פתח את ה‑Build → **Console Output** לעקוב אחרי השלבים:
   - Checkout
   - Terraform Init & Apply
   - Ansible Playbook
   - Validate Website

**זמן ריצה משוער:** כ‑10–15 דקות (תלוי ב‑build של React).

### 3) בדיקת האתר אחרי Build מוצלח

בסוף ה‑Build, בשלב Terraform, מופיע output:

```
public_ip = "x.x.x.x"
```

פתח בדפדפן:

| מה לבדוק | כתובת |
|----------|--------|
| **אתר CV Builder** | `http://<public_ip>/` |
| **בדיקת API** | `http://<public_ip>/health` |

**התחברות לאפליקציה** – לפי פרטים בידיעון (משתמש admin מוגדר אוטומטית בהעלאת השרת).

### 4) מה אמור להופיע בהצלחה

- Jenkins: **Finished: SUCCESS** (ירוק)
- Console – שלב Validate מציג תשובה מ‑`/health` ואת כותרת **CV Builder** בדף הבית
- בדפדפן – מסך התחברות / עורך קורות חיים

---

## בונוס – פריסת אפליקציה מלאה

במקום דף HTML סטטי, ה‑Pipeline מפריס את **[Cv-Builder](https://github.com/MrBrosh/Cv-Builder)**:

- Frontend: React + Vite (מוגש דרך Nginx)
- Backend: Node.js + Express (רץ כ‑`systemd`, proxy ל‑`/api`)
- תכונות: עריכת קו"ח, תצוגה מקדימה, שמירה בשרת, שיפור טקסט ב‑AI (אם הוגדר מפתח Gemini)

---

## מבנה הריפוזיטורי

```
devops-final-project/
├── Jenkinsfile              # Pipeline (Checkout → Terraform → Ansible → Validate)
├── README.md                # מסמך זה
├── jenkins.Dockerfile       # Image מותאם: Jenkins + Terraform + Ansible
├── terraform/
│   ├── main.tf              # EC2, SG, key pair, inventory, AMI Ubuntu 24.04
│   ├── variables.tf
│   └── outputs.tf           # public_ip, inventory_path
└── ansible/
    ├── playbook.yml         # פריסת CV Builder
    └── templates/
        ├── nginx-cv-builder.conf.j2
        ├── cv-builder.service.j2
        └── server.env.j2
```

---

## שלבי ה‑Pipeline (פירוט)

| שלב | כלי | פעולה |
|-----|-----|--------|
| Checkout | Git | משיכת קוד מ‑GitHub |
| Terraform Init & Apply | Terraform | יצירת/עדכון תשתית AWS |
| Ansible Playbook | Ansible | התקנת Node, Nginx, clone Cv-Builder, build, הפעלה |
| Validate Website | curl | `GET /health` + בדיקת דף הבית |

---

## דרישות טכניות (סביבת Jenkins)

- **Jenkins** רץ ב‑Docker על EC2 (`jenkins-devops:lts`)
- **Terraform** + **Ansible** מותקנים בתוך image
- **AWS Credentials** ב‑Jenkins (Global): `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`  
  *(לא נכללים ב‑Git)*

### הגדרות AWS

| פרמטר | ערך |
|--------|-----|
| Region | `us-east-1` |
| Instance type | `t3.micro` (Free Tier eligible) |
| AMI | Ubuntu 24.04 (נבחר אוטומטית) |
| פורטים פתוחים | 22 (SSH), 80 (HTTP), 8080 (Jenkins) |

---

## פתרון בעיות נפוצות

| בעיה | פתרון |
|------|--------|
| Build נכשל ב‑Terraform | בדוק AWS Credentials ב‑Jenkins; בדוק מכסת Free Tier |
| Ansible – SSH נכשל | המתן דקה והרץ שוב (שרת חדש עולה); בדוק Security Group לפורט 22 |
| Build נכשל ב‑npm | שרת קטן – הוסף swap; הרץ Build שוב |
| האתר לא נטען | בדוק `public_ip` מה‑output; וודא SG פותח פורט 80 |
| Jenkins לא נגיש | וודא שפורט 8080 פתוח ב‑Security Group |

---

## קישורים

| משאב | קישור |
|------|--------|
| ריפוזיטורי DevOps (מטלה) | https://github.com/MrBrosh/devops-final-project |
| ריפוזיטורי CV Builder | https://github.com/MrBrosh/Cv-Builder |
| Jenkins | http://13.63.160.119:8080 |

---

## הערות אבטחה

- מפתחות AWS, SSH וסיסמאות **לא** נשמרים ב‑Git
- גישת המרצה ל‑Jenkins מוגבלת (ללא Admin)
- מומלץ להגביל Security Group לפורט 8080 ל‑IP ספציפי לאחר בדיקת המטלה

---

**בהצלחה!**
