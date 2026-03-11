import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/checkout_controller.dart';
import '../../../data/models/cart_model.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Checkout",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Delivery Address"),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildDropdownField("District", controller.districtController.text, controller.districts)),
                const SizedBox(width: 16),
                Expanded(child: _buildDropdownField("City", controller.cityController.text, controller.cities)),
              ],
            ),
            const SizedBox(height: 16),
            _buildInputField("Address", "Example: House no 32,street,etc", controller.addressController),
            const SizedBox(height: 16),
            _buildInputField("Special Instructions", "enter your full address", controller.specialInstructionsController),
            const SizedBox(height: 24),
            _buildSectionTitle("Payment Method"),
            const SizedBox(height: 12),
            _buildPaymentMethodOption("Online"),
            _buildPaymentMethodOption("Cash"),
            const SizedBox(height: 32),
            _buildSectionTitle("Order Summary"),
            const SizedBox(height: 12),
            _buildOrderSummaryList(),
            const Divider(height: 32),
            _buildSummaryRow("Subtotal", "TK ${controller.subtotal.toStringAsFixed(0)}"),
            const SizedBox(height: 8),
            _buildSummaryRow("Delivery Fee", "TK ${controller.deliveryFee.toStringAsFixed(0)}"),
            const SizedBox(height: 16),
            _buildSummaryRow("Total", "TK ${controller.total.toStringAsFixed(0)}", isTotal: true),
            const SizedBox(height: 40),
            _buildCheckoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget _buildDropdownField(String label, String value, RxList<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
              onChanged: (val) {
                if (label == "District") controller.districtController.text = val!;
                else controller.cityController.text = val!;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController textController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodOption(String method) {
    return Obx(() {
      final isSelected = controller.selectedPaymentMethod.value == method;
      return GestureDetector(
        onTap: () => controller.setPaymentMethod(method),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF006437) : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Color(0xFF006437),
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                method,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildOrderSummaryList() {
    final items = controller.cart?.items ?? [];
    return Column(
      children: items.map((item) {
        final String name = item.partyMenu != null 
            ? item.partyMenu!['title'] 
            : (item.product != null ? item.product!['name'] : 'Unknown');
        
        final double price = item.variation != null 
            ? (item.variation!['price'] as num).toDouble() 
            : (item.partyMenu != null ? (item.partyMenu!['price'] as num).toDouble() : 0.0);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${item.quantity}x $name", style: TextStyle(color: Colors.grey[700], fontSize: 14)),
              Text("Tk ${price.toStringAsFixed(0)}", style: TextStyle(color: Colors.grey[800], fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? Colors.black : Colors.grey[600],
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 15 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.processCheckout,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF006437),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
        ),
        child: const Text(
          "Checkout",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
