#!/bin/bash

L_SIMBOLOS=("|" "/" "-" "\\")
INTERVALO=0.2
T_SIMBOLOS=${#L_SIMBOLOS[@]}

menu_principal() {
    dialog --backtitle "Gerência da Rede" \
           --title "Menu Principal" \
           --menu "Escolha uma opção:" 0 0 0 \
           1 "Informações das Interfaces de Rede" \
           2 "Configurar o IP e a Máscara de forma temporária" \
           3 "Habilitar Interface de Rede" \
           4 "Desabilitar Interface de Rede" \
           5 "Configurar as configurações de rede de forma permanente" \
           6 "Obter IP via DHCP" \
           7 "Tabela de Rotas" \
           8 "Adicionar Gateway" \
           9 "Deletar Gateway" \
           0 "Sair" \
           2>temp.txt
}

informacoes_interfaces() {
    dialog --backtitle "Gerência da Rede" \
           --title "Informações das Interfaces de Rede" \
           --msgbox "$(ip a)" 0 0
}

configurar_temporario() {
    dialog --backtitle "Gerência da Rede" \
           --title "Configurar IP e Máscara de forma temporária" \
           --inputbox "Informe o nome da interface de rede:" 0 0 "" 2>temp.txt
    INTERFACE_NAME=$(cat temp.txt)
    dialog --backtitle "Gerência da Rede" \
           --title "Configurar IP e Máscara de forma temporária" \
           --inputbox "Informe o endereço IP desejado:" 0 0 "" 2>temp.txt
    ENDERECO_IP=$(cat temp.txt)
    dialog --backtitle "Gerência da Rede" \
           --title "Configurar IP e Máscara de forma temporária" \
           --inputbox "Informe o endereço da máscara de rede:" 0 0 "" 2>temp.txt
    MASCARA=$(cat temp.txt)
    ifconfig "$INTERFACE_NAME" "$ENDERECO_IP" netmask "$MASCARA"
    dialog --backtitle "Gerência da Rede" \
           --title "Configurar IP e Máscara de forma temporária" \
           --msgbox "Operação realizada com sucesso!" 0 0
}

habilitar_interface() {
    dialog --backtitle "Gerência da Rede" \
           --title "Habilitar Interface de Rede" \
           --inputbox "Informe o nome da interface de rede a ser habilitada:" 0 0 "" 2>temp.txt
    H_REDE=$(cat temp.txt)
    ifconfig "$H_REDE" up
    dialog --backtitle "Gerência da Rede" \
           --title "Habilitar Interface de Rede" \
           --msgbox "Interface $H_REDE habilitada" 0 0
}

desabilitar_interface() {
    dialog --backtitle "Gerência da Rede" \
           --title "Desabilitar Interface de Rede" \
           --inputbox "Informe o nome da interface de rede a ser desabilitada:" 0 0 "" 2>temp.txt
    D_REDE=$(cat temp.txt)
    ifconfig "$D_REDE" down
    dialog --backtitle "Gerência da Rede" \
           --title "Desabilitar Interface de Rede" \
           --msgbox "Interface $D_REDE desabilitada" 0 0
}

configurar_permanente() {
    dialog --backtitle "Gerência da Rede" \
           --title "Configurar as configurações de rede de forma permanente" \
           --menu "Informe seu SO:" 0 0 0 \
           1 "Debian" \
           2 "Ubuntu" \
           2>temp.txt
    DISTRO=$(cat temp.txt)

    if [ "$DISTRO" = "1" ]; then
        dialog --backtitle "Gerência da Rede" \
               --title "Configurar as configurações de rede de forma permanente" \
               --menu "Você quer editar manualmente ou deseja apenas informar as credenciais?" 0 0 0 \
               1 "Manual" \
               2 "Automatizado" \
               2>temp.txt
        METODO=$(cat temp.txt)

        if [ "$METODO" = "1" ]; then
            dialog --backtitle "Gerência da Rede" \
                   --title "Configurar as configurações de rede de forma permanente" \
                   --menu "Escolha um editor:" 0 0 0 \
                   1 "vi" \
                   2 "nano" \
                   2>temp.txt
            EDITOR=$(cat temp.txt)

            if [ "$EDITOR" = "1" ]; then
                vi /etc/network/interfaces
            elif [ "$EDITOR" = "2" ]; then
                nano /etc/network/interfaces
            else
                dialog --backtitle "Gerência da Rede" \
                       --title "Configurar as configurações de rede de forma permanente" \
                       --msgbox "(｡•́︿•̀｡) Editor inválido!" 0 0
            fi
        elif [ "$METODO" = "2" ]; then
            dialog --backtitle "Gerência da Rede" \
                   --title "Configurar as configurações de rede de forma permanente" \
                   --inputbox "Informe o nome da interface:" 0 0 "" 2>temp.txt
            V_INTERFACE=$(cat temp.txt)
            dialog --backtitle "Gerência da Rede" \
                   --title "Configurar as configurações de rede de forma permanente" \
                   --inputbox "Informe o endereço IP desejado:" 0 0 "" 2>temp.txt
            V_IP=$(cat temp.txt)
            dialog --backtitle "Gerência da Rede" \
                   --title "Configurar as configurações de rede de forma permanente" \
                   --inputbox "Informe a máscara de rede desejada:" 0 0 "" 2>temp.txt
            V_MASCARA=$(cat temp.txt)
            FILE="/etc/network/interfaces"
            bash -c "echo \"# Interface de rede $V_INTERFACE
auto $V_INTERFACE
allow-hotplug $V_INTERFACE
iface $V_INTERFACE inet static
    address $V_IP
    netmask $V_MASCARA

\" >> \"$FILE\""
            dialog --backtitle "Gerência da Rede" \
                   --title "Configurar as configurações de rede de forma permanente" \
                   --msgbox "Operação realizada com sucesso!\nRealize a reinicialização da rede para que as alterações tenham efeito!\nUse o comando a seguir caso esteja no Debian:\nsudo systemctl restart networking.service\nCaso não tenha funcionado, reveja o arquivo /etc/network/interfaces e verifique se as informações estão corretas." 0 0
        else
            dialog --backtitle "Gerência da Rede" \
                   --title "Configurar as configurações de rede de forma permanente" \
                   --msgbox "(｡•́︿•̀｡) Opção inválida!" 0 0
        fi
    elif [ "$DISTRO" = "2" ]; then
        dialog --backtitle "Gerência da Rede" \
               --title "Configurar as configurações de rede de forma permanente" \
               --msgbox "Não implementado ainda!" 0 0
    else
        dialog --backtitle "Gerência da Rede" \
               --title "Configurar as configurações de rede de forma permanente" \
               --msgbox "(｡•́︿•̀｡) SO inválido!" 0 0
    fi
}

obter_dhcp() {
    dialog --backtitle "Gerência da Rede" \
           --title "Obter IP via DHCP" \
           --msgbox "$(dhclient)" 0 0
}

tabela_rotas() {
    dialog --backtitle "Gerência da Rede" \
           --title "Tabela de Rotas" \
           --msgbox "$(route)" 0 0
}

adicionar_gateway() {
    dialog --backtitle "Gerência da Rede" \
           --title "Adicionar Gateway" \
           --inputbox "Informe a linha onde será inserido o gateway (lembrando que as linhas posteriores serão deslocadas para baixo e o gateway precisa ir para uma linha já existente):" 0 0 "" 2>temp.txt
    LINHA=$(cat temp.txt)
    dialog --backtitle "Gerência da Rede" \
           --title "Adicionar Gateway" \
           --inputbox "Informe o gateway desejado:" 0 0 "" 2>temp.txt
    GATEWAY0=$(cat temp.txt)
    GATEWAY="    gateway $GATEWAY0"
    sed -i "${LINHA}i\\""$GATEWAY" "/etc/network/interfaces"
    dialog --backtitle "Gerência da Rede" \
           --title "Adicionar Gateway" \
           --msgbox "Gateway adicionado com sucesso!" 0 0
}

deletar_gateway() {
    dialog --backtitle "Gerência da Rede" \
           --title "Deletar Gateway" \
           --inputbox "Informe a linha onde será deletado o gateway (lembrando que essa operação irá apagar a linha informada mesmo que não seja o gateway; o restante será deslocado para cima!):" 0 0 "" 2>temp.txt
    LINHA2=$(cat temp.txt)
    sed -i "${LINHA2}d" "/etc/network/interfaces"
    dialog --backtitle "Gerência da Rede" \
           --title "Deletar Gateway" \
           --msgbox "Gateway removido com sucesso!" 0 0
}

if [ "$EUID" -ne 0 ]
  then echo "Por favor, execute como root"
  exit
fi

if ! command -v dialog &> /dev/null; then
        echo "--> O pacote dialog não está instalado. Instalando..."
        apt-get install dialog -y
fi

# Loop principal
while true; do
    menu_principal

    ESCOLHA=$(cat temp.txt)

    case "$ESCOLHA" in
        1) informacoes_interfaces ;;
        2) configurar_temporario ;;
        3) habilitar_interface ;;
        4) desabilitar_interface ;;
        5) configurar_permanente ;;
        6) obter_dhcp ;;
        7) tabela_rotas ;;
        8) adicionar_gateway ;;
        9) deletar_gateway ;;
        0) break ;;
        *) dialog --backtitle "Gerência da Rede" \
                  --title "Opção inválida" \
                  --msgbox "(｡•́︿•̀｡) Opção inválida! Por favor, escolha uma opção válida." 0 0 ;;
    esac
done

clear