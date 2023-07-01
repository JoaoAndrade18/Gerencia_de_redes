#! /bin/bash

L_SIMBOLOS=("|" "/" "-" "\\")
INTERVALO=0.2
T_SIMBOLOS=${#L_SIMBOLOS[@]}

echo
echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo "		    Gerência da Rede 		               "
echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo 1 – Informações das Interfaces de Rede
echo 2 – Configurar o IP e a Máscara de forma temporária
echo 3 – Habilitar Interface de Rede
echo 4 – Desabilitar Interface de Rede
echo 5 – Configurar as configurações de rede de forma permanente
echo 6 – Obter IP via DHCP
echo 7 – Tabela de Rotas
echo 8 – Adicionar Gateway
echo 9 – Deletar gateway
echo 0 – Sair
echo 

while true; do
	echo "\\
-> escolha um número referente a opção desejada, h para ver os comandos: "
	while true; do
		for ((i=0; i<$T_SIMBOLOS ; i++)); do
	                SIMBOLO=${L_SIMBOLOS[i]}
	                echo -ne "\r$SIMBOLO "
	                sleep $INTERVALO
	        done
		read -t 0.1 -n 1 ESCOLHA
		if [[ -n $ESCOLHA ]]; then
			break
		fi
	done
	case $ESCOLHA in
	  	1)
	  		ip -c a
		;;
		2)
			echo " - Configurando IP e Mascara de forma TEMPORÁRIA!!"
			echo " - Informe o nome da interface de rede: "
			read INTERFACE_NAME
			echo " - Informe o endereço ip desejado: "
			read ENDERECO_IP
			echo " - Informe o endereço da mascara de rede: "
			read MASCARA
			sudo ifconfig $INTERFACE_NAME $ENDERECO_IP netmask $MASCARA
		;;
		3)
			echo " - Informe o nome da interface de rede a ser habilitada:"
			read H_REDE
			sudo ifconfig $H_REDE up
		;;
		4)
			echo " - Informe o nome da interface de rede a ser desabilitada:"
			read D_REDE
			sudo ifconfig $D_REDE down
		;;
	 	5)
			echo " - Informe seu SO: 1 - Debian, 2 - Ubuntu"
			read DISTRO
			if [ $DISTRO = "1" ]; then
				echo " - Você quer editar na mão ou deseja só informar as credenciais? 1 - manual, 2 - automatizado"
				read METODO
				if [ $METODO = "1" ]; then
					echo " - Escolha um editor: 1 - vi, 2 - nano"
					read EDITOR
					if [ $EDITOR = "1" ]; then
						sudo vi /etc/network/interfaces
					elif [ $EDITOR = "2" ]; then
						sudo nano /etc/network/interfaces
					else
						echo "(｡•́︿•̀｡) Editor invalido!"
					fi
				elif [ $METODO = "2" ]; then
					echo " - Informe o nome da interface: "
					read V_INTERFACE
					echo " - Informe o endereço IP desejado: "
					read V_IP
					echo " - Informe a mascara de rede desejada: "
					read V_MASCARA
					FILE="/etc/network/interfaces"
					sudo bash -c "echo "#interface de rede $V_INTERFACE
auto $V_INTERFACE
allow-hotplug $V_INTERFACE
iface $V_INTERFACE inet static
	address $V_IP
	netmask $V_MASCARA" >> \"$FILE\""
					echo "operação realizada com sucesso!"
					echo "Realize a reinicialização da rede para que as alterações tenham efeito!" 
					echo Use o comando a seguir caso esteja no debian: sudo systemctl restart networking.service
					echo Caso nao tenha funcionado, reveja o arquivo /etc/network/interfaces e verifique se as informações estão corretas.
				else
					echo "(｡•́︿•̀｡) Opcao invalida!"
				fi
			elif [ $DISTRO = "2" ]; then
				echo "Não implementado ainda!"
			else
				echo "(｡•́︿•̀｡) SO invalido!"
			fi
		;;
		6)
			sudo dhclient
		;;
		7)
			route
		;;
		8)
			FILE="/etc/network/interfaces"
			echo " - Informe a linha onde será inserido o geteway, lembrando que as linhas posteriores serão deslocadas para baixo:"
			read LINHA
			echo " - Informe o gateway desejado: "
			read GATEWAY0
			GATEWAY="        gateway $GATEWAY0"
			sudo sed -i "${LINHA}i\\""$GATEWAY" "$FILE"
		;;
		9)
			FILE="/etc/network/interfaces"
			echo " - Informe a linha onde será deletado o gateway: lembrando que essa operação irá apagar a linha informada mesmo que não seja o gateway:\
 o restante será deslocado para cima!"
			read LINHA2
			sudo sed -i "${LINHA2}d" "$FILE"
		;;
		0)
			exit
		;;
		h)
		echo
		echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		echo "              	Gerência da Rede                       "
		echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		echo 1 – Informações das Interfaces de Rede
		echo 2 – Configurar o IP e a Máscara de forma temporária
		echo 3 – Habilitar Interface de Rede
		echo 4 – Desabilitar Interface de Rede
		echo 5 – Configurar as configurações de rede de forma permanente
		echo 6 – Obter IP via DHCP
		echo 7 – Tabela de Rotas
		echo 8 – Adicionar Gateway
		echo 9 – Deletar Gateway
		echo 0 – Sair
		echo
		;;
		*)
			echo "(｡•́︿•̀｡) Opção inválida."
		;;
	esac
done