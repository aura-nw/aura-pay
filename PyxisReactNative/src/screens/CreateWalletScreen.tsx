import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';

interface CreateWalletScreenProps {
    onGetOnboard: () => void; // Hàm được gọi khi nhấn "Get me onboard"
}

const CreateWalletScreen: React.FC<CreateWalletScreenProps> = ({ onGetOnboard }) => {
    const [walletAddress, setWalletAddress] = useState('aura15...g8vr'); // Ví dụ địa chỉ ví

    const handleGetOnboard = () => {
        // Thực hiện các hành động khi nút "Get me onboard" được nhấn
        onGetOnboard(); // Gọi hàm được truyền từ component cha
        // Các xử lý logic khác (nếu cần)
    };

    return (
        <View style={styles.container}>
            <View style={styles.content}>
                {/* Phần Lorem ipsum (có thể bỏ qua hoặc thay thế bằng nội dung khác) */}
                <Text style={styles.loremIpsum}>
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit...
                </Text>

                {/* Thông báo tạo ví thành công */}
                <View style={styles.successMessage}>
                    <Text style={styles.successText}>All done, your Pyxis wallet is ready</Text>
                </View>

                {/* Hiển thị địa chỉ ví */}
                <View style={styles.walletAddressContainer}>
                    <Text style={styles.walletAddressLabel}>Your wallet address</Text>
                    <Text style={styles.walletAddress}>{walletAddress}</Text>
                </View>
            </View>

            {/* Nút "Get me onboard" */}
            <TouchableOpacity style={styles.button} onPress={handleGetOnboard}>
                <Text style={styles.buttonText}>Get me onboard</Text>
            </TouchableOpacity>
        </View>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        padding: 20,
        justifyContent: 'space-between', // Canh giữa nội dung và nút
        backgroundColor: 'white', // Giả sử nền trắng
    },
    content: {
        alignItems: 'center', // Căn giữa nội dung theo chiều ngang
    },
    loremIpsum: {
        fontSize: 16,
        lineHeight: 24, // Khoảng cách giữa các dòng
        textAlign: 'center',
        marginBottom: 20, // Khoảng cách với thông báo
    },
    successMessage: {
        backgroundColor: '#D1FAE5', // Màu xanh nhạt (hoặc màu bạn muốn)
        padding: 15,
        borderRadius: 8,
        marginBottom: 20, // Khoảng cách với địa chỉ ví
    },
    successText: {
        fontSize: 18,
        fontWeight: 'bold',
        textAlign: 'center',
        color: '#065F46', // Màu xanh đậm (hoặc màu bạn muốn)
    },
    walletAddressContainer: {
        backgroundColor: '#F0F9FF', // Màu xanh rất nhạt (hoặc màu bạn muốn)
        padding: 15,
        borderRadius: 8,
        marginBottom: 40, // Khoảng cách với nút
    },
    walletAddressLabel: {
        fontSize: 14,
        color: '#3B82F6', // Màu xanh dương (hoặc màu bạn muốn)
        marginBottom: 5, // Khoảng cách với địa chỉ ví
    },
    walletAddress: {
        fontSize: 16,
        fontWeight: 'bold',
        textAlign: 'center',
    },
    button: {
        backgroundColor: '#007AFF',
        padding: 15,
        borderRadius: 8,
        alignItems: 'center',
    },
    buttonText: {
        color: 'white',
        fontSize: 16,
        fontWeight: 'bold',
    },
});


export default CreateWalletScreen;
