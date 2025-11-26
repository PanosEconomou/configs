#!/bin/bash

cat > "$HOME/.cache/SUNSET.sh" << 'EOF'
#!/bin/bash
export SUNSET='false'
EOF

chmod +x "$HOME/.cache/SUNSET.sh"
