#!/bin/bash

L_SIMBOLOS=("|" "/" "-" "\\")
INTERVALO=0.2
T_SIMBOLOS=${#L_SIMBOLOS[@]}

menu_principal() {
    ESCOLHA=$(zenity --window-size=800x800 --list --title "Menu Principal" --text "Escolha uma opção:" --column "Opção" \
        "Informações das Interfaces de Rede" \
        "Configurar o IP e a Máscara de forma temporária" \
        "Habilitar Interface de Rede" \
        "Desabilitar Interface de Rede" \
        "Configurar as configurações de rede de forma permanente" \
        "Obter IP via DHCP" \
        "Tabela de Rotas" \
        "Adicionar Gateway" \
        "Deletar Gateway" \
        "Sair")

    if [ "$?" -ne 0 ]; then
        ESCOLHA="Sair"
    fi
}


informacoes_interfaces() {
    INTERFACE_INFO=$(ifconfig)
    zenity --text-info --title "Informações das Interfaces de Rede" --filename=<(echo "$INTERFACE_INFO") --width=800 --height=800
}

configurar_temporario() {
    INTERFACE_NAME=$(zenity --entry --title "Configurar IP e Máscara de forma temporária" --text "Informe o nome da interface de rede:")
    if [ -z "$INTERFACE_NAME" ]; then
        zenity --error --title "Erro" --text "Nome da interface não fornecido!"
        return
    fi

    ENDERECO_IP=$(zenity --entry --title "Configurar IP e Máscara de forma temporária" --text "Informe o endereço IP desejado:")
    if [ -z "$ENDERECO_IP" ]; then
        zenity --error --title "Erro" --text "Endereço IP não fornecido!"
        return
    fi

    MASCARA=$(zenity --entry --title "Configurar IP e Máscara de forma temporária" --text "Informe o endereço da máscara de rede:")
    if [ -z "$MASCARA" ]; then
        zenity --error --title "Erro" --text "Máscara de rede não fornecida!"
        return
    fi

    ifconfig "$INTERFACE_NAME" "$ENDERECO_IP" netmask "$MASCARA"
    zenity --info --title "Configurar IP e Máscara de forma temporária" --text "Operação realizada com sucesso!"
}

habilitar_interface() {
    H_REDE=$(zenity --entry --title "Habilitar Interface de Rede" --text "Informe o nome da interface de rede a ser habilitada:")
    if [ -z "$H_REDE" ]; then
        zenity --error --title "Erro" --text "Nome da interface não fornecido!"
        return
    fi

    ifconfig "$H_REDE" up
    zenity --info --title "Habilitar Interface de Rede" --text "Interface $H_REDE habilitada"
}

desabilitar_interface() {
    D_REDE=$(zenity --entry --title "Desabilitar Interface de Rede" --text "Informe o nome da interface de rede a ser desabilitada:")
    if [ -z "$D_REDE" ]; then
        zenity --error --title "Erro" --text "Nome da interface não fornecido!"
        return
    fi

    ifconfig "$D_REDE" down
    zenity --info --title "Desabilitar Interface de Rede" --text "Interface $D_REDE desabilitada"
}

configurar_permanente() {
    DISTRO=$(zenity --entry --title "Configurar as configurações de rede de forma permanente" --text "Informe seu SO:" --entry-text "Debian")
    if [ -z "$DISTRO" ]; then
        zenity --error --title "Erro" --text "SO não fornecido!"
        return
    fi

    if [ "$DISTRO" = "Debian" ]; then
        METODO=$(zenity --list --title "Configurar as configurações de rede de forma permanente" --text "Escolha um método:" --column "Método" "Manual" "Automatizado")
        if [ -z "$METODO" ]; then
            zenity --error --title "Erro" --text "Método não fornecido!"
            return
        fi

        if [ "$METODO" = "Manual" ]; then
            EDITOR=$(zenity --list --title "Configurar as configurações de rede de forma permanente" --text "Escolha um editor:" --column "Editor" "vi" "nano")
            if [ -z "$EDITOR" ]; then
                zenity --error --title "Erro" --text "Editor não fornecido!"
                return
            fi

            if [ "$EDITOR" = "vi" ]; then
                vi /etc/network/interfaces
            elif [ "$EDITOR" = "nano" ]; then
                nano /etc/network/interfaces
            else
                zenity --error --title "Erro" --text "(｡•́︿•̀｡) Editor inválido!"
                return
            fi
        elif [ "$METODO" = "Automatizado" ]; then
            V_INTERFACE=$(zenity --entry --title "Configurar as configurações de rede de forma permanente" --text "Informe o nome da interface:")
            if [ -z "$V_INTERFACE" ]; then
                zenity --error --title "Erro" --text "Nome da interface não fornecido!"
                return
            fi

            V_IP=$(zenity --entry --title "Configurar as configurações de rede de forma permanente" --text "Informe o endereço IP desejado:")
            if [ -z "$V_IP" ]; then
                zenity --error --title "Erro" --text "Endereço IP não fornecido!"
                return
            fi

            V_MASCARA=$(zenity --entry --title "Configurar as configurações de rede de forma permanente" --text "Informe a máscara de rede desejada:")
            if [ -z "$V_MASCARA" ]; then
                zenity --error --title "Erro" --text "Máscara de rede não fornecida!"
                return
            fi

            FILE="/etc/network/interfaces"
            bash -c "echo \"# Interface de rede $V_INTERFACE
auto $V_INTERFACE
allow-hotplug $V_INTERFACE
iface $V_INTERFACE inet static
    address $V_IP
    netmask $V_MASCARA
\" >> \"$FILE\""
            zenity --info --title "Configurar as configurações de rede de forma permanente" --text "Operação realizada com sucesso!\nRealize a reinicialização da rede para que as alterações tenham efeito!\nUse o comando a seguir caso esteja no Debian:\nsudo systemctl restart networking.service\nCaso não tenha funcionado, reveja o arquivo /etc/network/interfaces e verifique se as informações estão corretas."
        else
            zenity --error --title "Erro" --text "(｡•́︿•̀｡) Opção inválida!"
            return
        fi
    else
        zenity --error --title "Erro" --text "(｡•́︿•̀｡) SO inválido!"
        return
    fi
}

obter_dhcp() {
    DHCP_INFO=$(dhclient)
    zenity --info --title "Obter IP via DHCP" --text "$DHCP_INFO"
}

tabela_rotas() {
    ROUTE_INFO=$(route)
    zenity --info --title "Tabela de Rotas" --text "$ROUTE_INFO"
}

adicionar_gateway() {
    LINHA=$(zenity --entry --title "Adicionar Gateway" --text "Informe a linha onde será inserido o gateway (lembrando que as linhas posteriores serão deslocadas para baixo e o gateway precisa ir para uma linha já existente):")
    if [ -z "$LINHA" ]; then
        zenity --error --title "Erro" --text "Linha não fornecida!"
        return
    fi

    GATEWAY0=$(zenity --entry --title "Adicionar Gateway" --text "Informe o gateway desejado:")
    if [ -z "$GATEWAY0" ]; then
        zenity --error --title "Erro" --text "Gateway não fornecido!"
        return
    fi

    GATEWAY="    gateway $GATEWAY0"
    sed -i "${LINHA}i\\""$GATEWAY" "/etc/network/interfaces"
    zenity --info --title "Adicionar Gateway" --text "Gateway adicionado com sucesso!"
}

deletar_gateway() {
    LINHA2=$(zenity --entry --title "Deletar Gateway" --text "Informe a linha onde será deletado o gateway (lembrando que essa operação irá apagar a linha informada mesmo que não seja o gateway; o restante será deslocado para cima!):")
    if [ -z "$LINHA2" ]; then
        zenity --error --title "Erro" --text "Linha não fornecida!"
        return
    fi

    sed -i "${LINHA2}d" "/etc/network/interfaces"
    zenity --info --title "Deletar Gateway" --text "Gateway removido com sucesso!"
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
    ESCOLHA=$(zenity --list --title "Menu Principal" --text "Escolha uma opção:" --column "Opção" \
        "Informações das Interfaces de Rede" \
        "Configurar o IP e a Máscara de forma temporária" \
        "Habilitar Interface de Rede" \
        "Desabilitar Interface de Rede" \
        "Configurar as configurações de rede de forma permanente" \
        "Obter IP via DHCP" \
        "Tabela de Rotas" \
        "Adicionar Gateway" \
        "Deletar Gateway" \
        "Sair" --width=600 --height=400)

    if [ -z "$ESCOLHA" ]; then
        zenity --error --title "Erro" --text "Nenhuma opção selecionada!"
        continue
    fi

    case "$ESCOLHA" in
        "Informações das Interfaces de Rede")
            informacoes_interfaces
            ;;
        "Configurar o IP e a Máscara de forma temporária")
            configurar_temporario
            ;;
        "Habilitar Interface de Rede")
            habilitar_interface
            ;;
        "Desabilitar Interface de Rede")
            desabilitar_interface
            ;;
        "Configurar as configurações de rede de forma permanente")
            configurar_permanente
            ;;
        "Obter IP via DHCP")
            obter_dhcp
            ;;
        "Tabela de Rotas")
            tabela_rotas
            ;;
        "Adicionar Gateway")
            adicionar_gateway
            ;;
        "Deletar Gateway")
            deletar_gateway
            ;;
        "Sair")
            break
            ;;
        *)
            zenity --error --title "Erro" --text "(｡•́︿•̀｡) Opção inválida!"
            ;;
    esac
done
