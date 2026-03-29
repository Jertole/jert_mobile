import 'package:flutter/material.dart';
import '../../../core/state/app_controller.dart';

class TerminalModal extends StatefulWidget {
  final AppController controller;

  const TerminalModal({
    super.key,
    required this.controller,
  });

  @override
  State<TerminalModal> createState() => _TerminalModalState();
}

class _TerminalModalState extends State<TerminalModal> {
  final TextEditingController reserveController =
      TextEditingController(text: '1000');

  String? terminalId;
  String serviceType = 'cold_storage';
  bool loading = false;
  String? errorText;

  @override
  void initState() {
    super.initState();
    final terminals = widget.controller.terminals;
    if (terminals.isNotEmpty) {
      terminalId = terminals.first.id;
      serviceType = terminals.first.serviceTypes.first;
    }
  }

  @override
  void dispose() {
    reserveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final terminals = controller.terminals;

    if (terminals.isEmpty) {
      return const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'No terminals available.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final selectedTerminal = terminals.firstWhere(
      (t) => t.id == terminalId,
      orElse: () => terminals.first,
    );

    final assetColor = _assetColor(selectedTerminal.assetType);

    return SafeArea(
      child: Container(
        color: const Color(0xFF0D141C),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Terminal Reserve',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Reserve JERT on Polygon through LeaseContract before using terminal services.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      initialValue: terminalId,
                      dropdownColor: const Color(0xFF111922),
                      isExpanded: true,
                      items: terminals
                          .map(
                            (t) => DropdownMenuItem<String>(
                              value: t.id,
                              child: Text(
                                '${t.id} — ${_assetLabel(t.assetType)} — ${t.country}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: _assetColor(t.assetType),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        final terminal =
                            terminals.firstWhere((t) => t.id == value);

                        setState(() {
                          terminalId = value;
                          serviceType = terminal.serviceTypes.first;
                          errorText = null;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Terminal',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _assetBadge(
                          _assetLabel(selectedTerminal.assetType),
                          assetColor,
                        ),
                        _neutralBadge(selectedTerminal.networkName),
                        _neutralBadge('Chain ${selectedTerminal.chainId}'),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _readOnlyField(
                      'Partner Level',
                      controller.partnershipLabel,
                    ),
                    _readOnlyField(
                      'Available JERT',
                      controller.balances.walletJert.toStringAsFixed(2),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue:
                          selectedTerminal.serviceTypes.contains(serviceType)
                              ? serviceType
                              : selectedTerminal.serviceTypes.first,
                      dropdownColor: const Color(0xFF111922),
                      isExpanded: true,
                      items: selectedTerminal.serviceTypes
                          .map(
                            (s) => DropdownMenuItem<String>(
                              value: s,
                              child: Text(
                                _serviceLabel(s),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          serviceType =
                              value ?? selectedTerminal.serviceTypes.first;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Service type',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _infoBox(
                      text: selectedTerminal.pricingNote,
                      color: assetColor,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: reserveController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Reserve JERT',
                        hintText: 'Enter reserve amount',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.03),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (errorText != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          errorText!,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: assetColor,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: loading ? null : _onReservePressed,
                        child: loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Reserve',
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Flow: buy JERT wherever convenient → reserve on Polygon → service metering → used part to treasury → unused part refunded.',
                      style: TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _readOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        readOnly: true,
        controller: TextEditingController(text: value),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.03),
        ),
      ),
    );
  }

  Widget _infoBox({
    required String text,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.10),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }

  Widget _assetBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _neutralBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  String _assetLabel(String value) {
    switch (value) {
      case 'cold':
        return 'COLD';
      case 'lcng':
        return 'LCNG';
      case 'dc':
        return 'DC';
      default:
        return value.toUpperCase();
    }
  }

  Color _assetColor(String value) {
    switch (value) {
      case 'cold':
        return const Color(0xFF2CF6FF);
      case 'lcng':
        return const Color(0xFFFFB347);
      case 'dc':
        return const Color(0xFFB388FF);
      default:
        return Colors.white70;
    }
  }

  String _serviceLabel(String value) {
    switch (value) {
      case 'cold_storage':
        return 'Cold Storage';
      case 'cold':
        return 'Cold Energy';
      case 'compute':
        return 'Compute';
      case 'sla':
        return 'SLA';
      default:
        return value;
    }
  }

  Future<void> _onReservePressed() async {
    setState(() {
      loading = true;
      errorText = null;
    });

    try {
      final amount = double.tryParse(reserveController.text.trim()) ?? 0;
      final selectedId = terminalId;

      if (selectedId == null) {
        throw Exception('Terminal must be selected.');
      }

      final terminal = widget.controller.terminals.firstWhere(
        (t) => t.id == selectedId,
      );

      await widget.controller.reserveJertForTerminal(
        TerminalReserveDraft(
          terminalId: selectedId,
          chainId: terminal.chainId,
          networkName: terminal.networkName,
          reserveAmount: amount,
          serviceType: serviceType,
        ),
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        errorText = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }
}
