#!/bin/bash

# © JoaoAndrade18 2023	

# Ao longo do codigo irei disponibilizar alguns comentários para facilitar o entendimento do código

# O código foi feito para ser executado no Debian

# "bash ./Geren_Rede.sh "caso o arquivo não esteja com permissão de execução, ou somente "./Geren_Rede.sh" caso o arquivo esteja com permissão de execução  

# a seguir esta a função que irá mostrar o menu principal
menu_principal() {
    dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
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

# a seguir esta a função que irá mostrar as informações das interfaces de rede
informacoes_interfaces() {
    ifconfig -a >temp.txt
    dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
           --title "Informações das Interfaces de Rede" \
           --textbox ./temp.txt \
           0 0
}

# a seguir esta a função que irá configurar o IP e a Máscara de forma temporária
configurar_temporario() {
    dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
           --title "Configurar IP e Máscara de forma temporária" \
           --inputbox "Informe o nome da interface de rede:" 0 0 "" 2>temp.txt
    INTERFACE_NAME=$(cat temp.txt)
    dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
           --title "Configurar IP e Máscara de forma temporária" \
           --inputbox "Informe o endereço IP desejado:" 0 0 "" 2>temp.txt
    ENDERECO_IP=$(cat temp.txt)
    dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
           --title "Configurar IP e Máscara de forma temporária" \
           --inputbox "Informe o endereço da máscara de rede:" 0 0 "" 2>temp.txt
    MASCARA=$(cat temp.txt)
    ifconfig "$INTERFACE_NAME" "$ENDERECO_IP" netmask "$MASCARA"  # comando para configurar o IP e a Máscara de forma temporária
    dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
           --title "Configurar IP e Máscara de forma temporária" \
           --msgbox "Operação realizada com sucesso!" 0 0
}

# a seguir esta a função que irá habilitar uma interface de rede
habilitar_interface() {
    dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
           --title "Habilitar Interface de Rede" \
           --inputbox "Informe o nome da interface de rede a ser habilitada:" 0 0 "" 2>temp.txt
    H_REDE=$(cat temp.txt)
    ifconfig "$H_REDE" up  # comando para habilitar uma interface de rede
    dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
           --title "Habilitar Interface de Rede" \
           --msgbox "Interface $H_REDE habilitada" 0 0
}

# a seguir esta a função que irá desabilitar uma interface de rede
desabilitar_interface() {
    dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
           --title "Desabilitar Interface de Rede" \
           --inputbox "Informe o nome da interface de rede a ser desabilitada:" 0 0 "" 2>temp.txt
    D_REDE=$(cat temp.txt)
    ifconfig "$D_REDE" down  # comando para desabilitar uma interface de rede
    dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
           --title "Desabilitar Interface de Rede" \
           --msgbox "Interface $D_REDE desabilitada" 0 0
}

# a seguir esta a função que irá configurar as configurações de rede de forma permanente
configurar_permanente() {
    dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
           --title "Configurar as configurações de rede de forma permanente" \
           --menu "Informe seu SO:" 0 0 0 \
           1 "Debian" \
           2 "Ubuntu" \
           2>temp.txt
    DISTRO=$(cat temp.txt)

    if [ "$DISTRO" = "1" ]; then # caso a distro seja Debian
        dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
               --title "Configurar as configurações de rede de forma permanente" \
               --menu "Você quer editar manualmente ou deseja apenas informar as credenciais?" 0 0 0 \
               1 "Manual" \
               2 "Automatizado" \
               2>temp.txt
        METODO=$(cat temp.txt)

        if [ "$METODO" = "1" ]; then # caso o método seja manual
            dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
                   --title "Configurar as configurações de rede de forma permanente" \
                   --menu "Escolha um editor:" 0 0 0 \
                   1 "vi" \
                   2 "nano" \
                   2>temp.txt
            EDITOR=$(cat temp.txt)

            if [ "$EDITOR" = "1" ]; then # caso o editor seja vi
                vi /etc/network/interfaces
            elif [ "$EDITOR" = "2" ]; then # caso o editor seja nano
                nano /etc/network/interfaces
            else # caso o editor seja inválido
                dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
                       --title "Configurar as configurações de rede de forma permanente" \
                       --msgbox "(｡•́︿•̀｡) Editor inválido!" 0 0
            fi
        elif [ "$METODO" = "2" ]; then # caso o método seja automatizado
            dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
                --title "Configurar as configurações de rede de forma permanente" \
                --menu "Informe o método:" 0 0 0 \
                1 "static" \
                2 "dhcp" \
                2>temp.txt
            FORMA=$(cat temp.txt)  

            if [ "$FORMA" = "1" ]; then # caso a forma seja static
                dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
                    --title "Configurar as configurações de rede de forma permanente" \
                    --inputbox "Informe o nome da interface:" 0 0 "" 2>temp.txt
                V_INTERFACE=$(cat temp.txt)
                dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
                    --title "Configurar as configurações de rede de forma permanente" \
                    --inputbox "Informe o endereço IP desejado:" 0 0 "" 2>temp.txt
                V_IP=$(cat temp.txt)
                dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
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
            dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
                   --title "Configurar as configurações de rede de forma permanente" \
                   --msgbox "Operação realizada com sucesso!\nCaso não tenha funcionado, reveja o arquivo /etc/network/interfaces e verifique se as informações estão corretas." 0 0
            
            dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
                   --title "Configurar as configurações de rede de forma permanente" \
                   --menu "Deseja reiniciar a rede?" 0 0 0 \
                   1 "Sim" \
                   2 "Não" \
                   2>temp.txt
            REDE=$(cat temp.txt)
            if [ "$REDE" = "1" ]; then # caso a rede seja reiniciada
                systemctl restart networking.service # comando para reiniciar a rede
                dhclient -r # comando para liberar o IP
            elif [ "$REDE" = "2" ]; then # caso a rede não seja reiniciada
                dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
                       --title "Configurar as configurações de rede de forma permanente" \
                       --msgbox "Reinicie a rede manualmente com o seguinte comando: systemctl restart networking.service!" 0 0
            else
                dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
                       --title "Configurar as configurações de rede de forma permanente" \
                       --msgbox "(｡•́︿•̀｡) Opção inválida!" 0 0
            fi
            
            elif [ "$FORMA" = "2" ]; then # caso a forma seja dhcp
                dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
                    --title "Configurar as configurações de rede de forma permanente" \
                    --inputbox "Informe o nome da interface:" 0 0 "" 2>temp.txt
                V_INTERFACE=$(cat temp.txt)
                FILE="/etc/network/interfaces"
                bash -c "echo \"# Interface de rede $V_INTERFACE
auto $V_INTERFACE
allow-hotplug $V_INTERFACE
iface $V_INTERFACE inet dhcp
\" >> \"$FILE\""
            dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
                   --title "Configurar as configurações de rede de forma permanente" \
                   --msgbox "Operação realizada com sucesso!\nCaso não tenha funcionado, reveja o arquivo /etc/network/interfaces e verifique se as informações estão corretas." 0 0
            
            dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
                   --title "Configurar as configurações de rede de forma permanente" \
                   --menu "Deseja reiniciar a rede?" 0 0 0 \
                   1 "Sim" \
                   2 "Não" \
                   2>temp.txt
            REDE=$(cat temp.txt)
            if [ "$REDE" = "1" ]; then  # caso a rede seja reiniciada
                systemctl restart networking.service # reinicia a rede
                dhclient -r # libera o ip 
            elif [ "$REDE" = "2" ]; then # caso a rede não seja reiniciada
                dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
                       --title "Configurar as configurações de rede de forma permanente" \
                       --msgbox "Reinicie a rede manualmente com o seguinte comando: systemctl restart networking.service!" 0 0
            else 
                dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
                       --title "Configurar as configurações de rede de forma permanente" \
                       --msgbox "(｡•́︿•̀｡) Opção inválida!" 0 0
            fi

            else # caso a forma seja inválida
                dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
                       --title "Configurar as configurações de rede de forma permanente" \
                       --msgbox "(｡•́︿•̀｡) Opção inválida!" 0 0
            fi  
        else # caso o método seja inválido
            dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
                   --title "Configurar as configurações de rede de forma permanente" \
                   --msgbox "(｡•́︿•̀｡) Opção inválida!" 0 0
        fi
    elif [ "$DISTRO" = "2" ]; then # caso a distro seja Ubuntu
        dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
               --title "Configurar as configurações de rede de forma permanente" \
               --msgbox "Não implementado ainda!" 0 0
    else # caso a distro seja inválida
        dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
               --title "Configurar as configurações de rede de forma permanente" \
               --msgbox "(｡•́︿•̀｡) SO inválido!" 0 0
    fi
}

# função para obter o IP via DHCP
obter_dhcp() {
    dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
           --title "Obter IP via DHCP" \
           --msgbox "$(dhclient)" 0 0
}

# função para obter a tabela de rotas
tabela_rotas() {
    dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
           --title "Tabela de Rotas" \
           --msgbox "$(route)" 0 0
}

# função para adicionar um gateway no arquivo interfaces
adicionar_gateway() {
    dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
           --title "Adicionar Gateway" \
           --inputbox "Informe a linha onde será inserido o gateway (lembrando que as linhas posteriores serão deslocadas para baixo e o gateway precisa ir para uma linha já existente):" 0 0 "" 2>temp.txt
    LINHA=$(cat temp.txt)
    dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
           --title "Adicionar Gateway" \
           --inputbox "Informe o gateway desejado:" 0 0 "" 2>temp.txt
    GATEWAY0=$(cat temp.txt)
    GATEWAY="    gateway $GATEWAY0"
    sed -i "${LINHA}i\\""$GATEWAY" "/etc/network/interfaces" # insere o gateway na linha informada
    dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
           --title "Adicionar Gateway" \
           --msgbox "Gateway adicionado com sucesso!" 0 0
}

# função para deletar um gateway no arquivo interfaces 
deletar_gateway() {
    dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
           --title "Deletar Gateway" \
           --inputbox "Informe a linha onde será deletado o gateway (lembrando que essa operação irá apagar a linha informada mesmo que não seja o gateway; o restante será deslocado para cima!):" 0 0 "" 2>temp.txt
    LINHA2=$(cat temp.txt)
    sed -i "${LINHA2}d" "/etc/network/interfaces" # deleta a linha informada
    dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
           --title "Deletar Gateway" \
           --msgbox "Gateway removido com sucesso!" 0 0
}

# função para o menu principal
if [ "$EUID" -ne 0 ]
  then echo "Por favor, execute como root"
  exit
fi

# Verifica se o dialog está instalado
if ! command -v dialog &> /dev/null; then
        echo "--> O pacote dialog não está instalado. Instalando..."
        apt-get install dialog -y
fi
# Verifica se o net-tools está instalado
if ! command -v netstat &> /dev/null; then
        echo "--> O pacote net-tools não está instalado. Instalando..."
        apt-get install net-tools -y
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
        *) dialog --backtitle "Gerência da Rede | © JoaoAndrade18 2023" \
                  --title "Opção inválida" \
                  --msgbox "(｡•́︿•̀｡) Opção inválida! Por favor, escolha uma opção válida." 0 0 ;;
    esac
done # fim do loop principal

clear # limpa a tela
